import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meteo/weather/data/models/weather_model.dart';
import 'package:meteo/forecast/data/models/forecast_model.dart';
import 'package:meteo/weather/data/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  // Suppression de toute variable static defaultCity ici pour éviter les retours en arrière

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

  // --- LOGIQUE DE TRAITEMENT DES ERREURS ---
  String _mapErrorToMessage(dynamic e) {
    // On vérifie les deux codes d'erreur possibles pour le GPS
    if (e.toString().contains('GPS_REQUIRED') || e.toString().contains('GPS_ERROR')) {
      return "Localisation impossible. L'activation du GPS est obligatoire pour voir la météo de votre position actuelle.";
    }
    return 'Erreur : $e';
  }

  // --- RÉCUPÉRATION MÉTÉO SIMPLE ---
  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadingState());
    try {
      final weather = await weatherRepository.getCurrentWeather(cityName: event.cityName);
      emit(WeatherLoadedState(weather: weather));
    } catch (e) {
      emit(WeatherErrorState(message: _mapErrorToMessage(e)));
    }
  }

  // --- ACTUALISATION ---
  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    String? cityToRefresh = event.cityName;

    // Si on n'a pas de ville dans l'événement, on essaie de récupérer celle du state actuel
    if (cityToRefresh == null && state is WeatherLoadedState) {
      cityToRefresh = (state as WeatherLoadedState).weather.cityName;
    }

    // On montre qu'on actualise
    if (state is WeatherLoadedState) {
      final currentState = state as WeatherLoadedState;
      emit(WeatherRefreshingState(
        weather: currentState.weather,
        forecasts: currentState.forecasts,
      ));
    } else {
      emit(WeatherLoadingState());
    }

    try {
      // Si cityToRefresh est toujours nul, le Repo tentera le GPS. 
      // S'il échoue, il lancera GPS_REQUIRED et on tombera dans le catch.
      final weather = await weatherRepository.getCurrentWeather(cityName: cityToRefresh);
      final forecasts = await weatherRepository.getForecast(cityName: cityToRefresh);
      
      emit(WeatherLoadedState(weather: weather, forecasts: forecasts));
    } catch (e) {
      // ICI : Si ça rate, on émet l'erreur et on ne revient JAMAIS à Niamey
      emit(WeatherErrorState(message: _mapErrorToMessage(e)));
    }
  }

  // --- RÉCUPÉRATION COMPLÈTE (GPS PAR DÉFAUT) ---
  Future<void> _onFetchWeatherWithForecast(
    FetchWeatherWithForecastEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadingState());
    try {
      // Future.wait lancera les deux appels. Si l'un des deux (ou les deux) 
      // échoue à cause du GPS, le Repo lancera GPS_REQUIRED.
      final results = await Future.wait([
        weatherRepository.getCurrentWeather(cityName: event.cityName),
        weatherRepository.getForecast(cityName: event.cityName),
      ]);

      emit(WeatherLoadedState(
        weather: results[0] as WeatherModel,
        forecasts: results[1] as List<ForecastModel>,
      ));
    } catch (e) {
      // On bloque sur l'état d'erreur
      emit(WeatherErrorState(message: _mapErrorToMessage(e)));
    }
  }

  // --- MÉTHODES D'AIDE (HELPERS) ---

  void fetchDefaultWeather() {
    add(const FetchWeatherEvent(cityName: null));
  }

  void fetchDefaultWeatherWithForecast() {
    add(const FetchWeatherWithForecastEvent(cityName: null));
  }
}