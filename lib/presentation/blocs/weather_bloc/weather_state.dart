part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object> get props => [];
}

class WeatherInitialState extends WeatherState {
  const WeatherInitialState();
}

class WeatherLoadingState extends WeatherState {
  const WeatherLoadingState();
}

class WeatherRefreshingState extends WeatherState {
  final WeatherModel weather;
  final List<ForecastModel>? forecasts;
  
  const WeatherRefreshingState({
    required this.weather,
    this.forecasts,
  });
  
  @override
  List<Object> get props => [weather, forecasts ?? []];
}

class WeatherLoadedState extends WeatherState {
  final WeatherModel weather;
  final List<ForecastModel>? forecasts;
  
  const WeatherLoadedState({
    required this.weather,
    this.forecasts,
  });
  
  @override
  List<Object> get props => [weather, forecasts ?? []];
}

class WeatherErrorState extends WeatherState {
  final String message;
  
  const WeatherErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}