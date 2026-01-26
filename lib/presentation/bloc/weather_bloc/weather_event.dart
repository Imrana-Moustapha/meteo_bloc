part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String cityName;

  const FetchWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchWeatherByLocation extends WeatherEvent {}

class RefreshWeather extends WeatherEvent {
  final String cityName;

  const RefreshWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchForecast extends WeatherEvent {
  final String cityName;

  const FetchForecast(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class ClearWeather extends WeatherEvent {}