part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

enum ForecastStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final ForecastStatus forecastStatus;
  final Weather? weather;
  final List<Forecast>? forecast;
  final String? errorMessage;
  final String? cityName;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.forecastStatus = ForecastStatus.initial,
    this.weather,
    this.forecast,
    this.errorMessage,
    this.cityName,
  });

  bool get hasWeather => weather != null;
  bool get hasForecast => forecast != null && forecast!.isNotEmpty;

  WeatherState copyWith({
    WeatherStatus? status,
    ForecastStatus? forecastStatus,
    Weather? weather,
    List<Forecast>? forecast,
    String? errorMessage,
    String? cityName,
  }) {
    return WeatherState(
      status: status ?? this.status,
      forecastStatus: forecastStatus ?? this.forecastStatus,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      errorMessage: errorMessage ?? this.errorMessage,
      cityName: cityName ?? this.cityName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        forecastStatus,
        weather,
        forecast,
        errorMessage,
        cityName,
      ];
}