part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object?> get props => [];
}

/// État au tout début du lancement (avant l'appel GPS)
class WeatherInitialState extends WeatherState {
  const WeatherInitialState();
}

/// État pendant la récupération (GPS ou API)
class WeatherLoadingState extends WeatherState {
  const WeatherLoadingState();
}

/// État d'actualisation (conserve les données actuelles à l'écran)
class WeatherRefreshingState extends WeatherState {
  final WeatherModel weather;
  final List<ForecastModel>? forecasts;
  
  const WeatherRefreshingState({
    required this.weather,
    this.forecasts,
  });
  
  @override
  List<Object?> get props => [weather, forecasts];
}

/// État de succès : Météo trouvée (soit via GPS, soit via Recherche)
class WeatherLoadedState extends WeatherState {
  final WeatherModel weather;
  final List<ForecastModel>? forecasts;
  
  const WeatherLoadedState({
    required this.weather,
    this.forecasts,
  });
  
  @override
  List<Object?> get props => [weather, forecasts];
}

/// État d'erreur : C'est ici que s'affichera ton message "GPS Requis"
/// sans jamais rebasculer sur Niamey.
class WeatherErrorState extends WeatherState {
  final String message;
  
  const WeatherErrorState({required this.message});
  
  @override
  List<Object?> get props => [message];
}