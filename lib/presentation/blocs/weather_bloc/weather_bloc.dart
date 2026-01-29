import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  
  static const String defaultCity = 'Niger';
  
  WeatherBloc(this.weatherRepository) : super(WeatherInitialState()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<FetchWeatherWithForecastEvent>(_onFetchWeatherWithForecast);
  }
  
  @override
  void onTransition(Transition<WeatherEvent, WeatherState> transition) {
    print(transition);
    super.onTransition(transition);
  }
  
  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadingState());
    
    try {
      final city = event.cityName ?? defaultCity;
      final weather = await weatherRepository.getCurrentWeather(cityName: city);
      emit(WeatherLoadedState(weather: weather));
    } catch (e) {
      emit(WeatherErrorState(message: 'Erreur: $e'));
    }
  }
  
  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoadedState) {
      final currentState = state as WeatherLoadedState;
      emit(WeatherRefreshingState(
        weather: currentState.weather,
        forecasts: currentState.forecasts,
      ));
    }
    
    try {
      final city = event.cityName ?? defaultCity; 
      final weather = await weatherRepository.getCurrentWeather(cityName: city);
      emit(WeatherLoadedState(weather: weather));
    } catch (e) {
      emit(WeatherErrorState(message: 'Erreur: $e'));
    }
  }
  
  Future<void> _onFetchWeatherWithForecast(
    FetchWeatherWithForecastEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadingState());
    
    try {
      final city = event.cityName ?? defaultCity; 
      
      final weatherFuture = weatherRepository.getCurrentWeather(cityName: city);
      final forecastsFuture = weatherRepository.getForecast(cityName: city);
      
      final results = await Future.wait([weatherFuture, forecastsFuture]);
      final weather = results[0] as WeatherModel;
      final forecasts = results[1] as List<ForecastModel>;
      
      emit(WeatherLoadedState(
        weather: weather,
        forecasts: forecasts,
      ));
    } catch (e) {
      emit(WeatherErrorState(message: 'Erreur: $e'));
    }
  }
  
  void fetchDefaultWeather() {
    add(FetchWeatherEvent(cityName: defaultCity));
  }
  
  void fetchDefaultWeatherWithForecast() {
    add(FetchWeatherWithForecastEvent(cityName: defaultCity));
  }
}