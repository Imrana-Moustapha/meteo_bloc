part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  
  @override
  List<Object> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final String? cityName;
  
  const FetchWeatherEvent({this.cityName});
  
  @override
  List<Object> get props => [cityName ?? 'Niger'];
}

class RefreshWeatherEvent extends WeatherEvent {
  final String? cityName;
  
  const RefreshWeatherEvent({this.cityName});
  
  @override
  List<Object> get props => [cityName ?? 'Niger'];
}

class FetchWeatherWithForecastEvent extends WeatherEvent {
  final String? cityName;
  
  const FetchWeatherWithForecastEvent({this.cityName});
  
  @override
  List<Object> get props => [cityName ?? 'Niger'];
}