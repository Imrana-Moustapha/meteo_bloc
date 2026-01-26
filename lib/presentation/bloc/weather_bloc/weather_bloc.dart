import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteo/core/utils/helpers.dart';
import 'package:meteo/domain/entities/forecast.dart';
import 'package:meteo/domain/entities/weather.dart';
import 'package:meteo/domain/usecases/get_forecast.dart';
import 'package:meteo/domain/usecases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final GetForecast getForecast;
  StreamSubscription<Position>? _positionSubscription;

  WeatherBloc({
    required this.getWeather,
    required this.getForecast,
  }) : super(const WeatherState()) {
    on<FetchWeather>(_onFetchWeather);
    on<FetchWeatherByLocation>(_onFetchWeatherByLocation);
    on<RefreshWeather>(_onRefreshWeather);
    on<FetchForecast>(_onFetchForecast);
    on<ClearWeather>(_onClearWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(
      status: WeatherStatus.loading,
      cityName: event.cityName,
    ));

    final result = await getWeather.execute(event.cityName);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: WeatherStatus.error,
          errorMessage: failure.message,
        ));
      },
      (weather) {
        emit(state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onFetchWeatherByLocation(
    FetchWeatherByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final hasPermission = await Helpers.checkLocationPermission();
      if (!hasPermission) {
        emit(state.copyWith(
          status: WeatherStatus.error,
          errorMessage: 'Location permission denied',
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.medium,
      );

      final result = await getWeather.executeByCoordinates(
        position.latitude,
        position.longitude,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: WeatherStatus.error,
            errorMessage: failure.message,
          ));
        },
        (weather) {
          emit(state.copyWith(
            status: WeatherStatus.loaded,
            weather: weather,
            cityName: weather.cityName,
            errorMessage: null,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeather event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.weather == null) return;

    emit(state.copyWith(
      status: WeatherStatus.loading,
      cityName: event.cityName,
    ));

    final result = await getWeather.execute(event.cityName);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: WeatherStatus.error,
          errorMessage: failure.message,
        ));
      },
      (weather) {
        emit(state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onFetchForecast(
    FetchForecast event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(forecastStatus: ForecastStatus.loading));

    final result = await getForecast.execute(event.cityName);

    result.fold(
      (failure) {
        emit(state.copyWith(
          forecastStatus: ForecastStatus.error,
          errorMessage: failure.message,
        ));
      },
      (forecast) {
        emit(state.copyWith(
          forecastStatus: ForecastStatus.loaded,
          forecast: forecast,
          errorMessage: null,
        ));
      },
    );
  }

  void _onClearWeather(
    ClearWeather event,
    Emitter<WeatherState> emit,
  ) {
    emit(const WeatherState());
  }

  void startLocationUpdates() {
    // CORRECTION : Utilisez la méthode correcte pour obtenir le flux de positions
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 1000, // 1 km
      ),
    ).listen((position) {
      add(FetchWeatherByLocation());
    });
  }

  void stopLocationUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  Future<void> close() {
    stopLocationUpdates();
    return super.close();
  }
}