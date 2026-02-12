part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  
  @override
  List<Object?> get props => []; 
}

/// Événement pour charger la météo actuelle
class FetchWeatherEvent extends WeatherEvent {
  final String? cityName;
  
  const FetchWeatherEvent({this.cityName});
  
  @override
  List<Object?> get props => [cityName]; 
}

/// Événement pour rafraîchir les données
class RefreshWeatherEvent extends WeatherEvent {
  final String? cityName;
  
  const RefreshWeatherEvent({this.cityName});
  
  @override
  List<Object?> get props => [cityName];
}

/// Événement principal (Météo + Prévisions) - Utilisé au démarrage avec cityName = null
class FetchWeatherWithForecastEvent extends WeatherEvent {
  final String? cityName;
  
  const FetchWeatherWithForecastEvent({this.cityName});
  
  @override
  List<Object?> get props => [cityName];
}