import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int pressure;
  final String description;
  final String iconCode;
  final int conditionId;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? sunrise;
  final int? sunset;
  final int? cloudiness;
  final DateTime lastUpdated;

  const Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.conditionId,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.sunrise,
    this.sunset,
    this.cloudiness,
    required this.lastUpdated,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get formattedTemperature => '${temperature.toStringAsFixed(1)}°C';

  String get windDirection {
    if (windDegree >= 337.5 || windDegree < 22.5) return 'N';
    if (windDegree >= 22.5 && windDegree < 67.5) return 'NE';
    if (windDegree >= 67.5 && windDegree < 112.5) return 'E';
    if (windDegree >= 112.5 && windDegree < 157.5) return 'SE';
    if (windDegree >= 157.5 && windDegree < 202.5) return 'S';
    if (windDegree >= 202.5 && windDegree < 247.5) return 'SW';
    if (windDegree >= 247.5 && windDegree < 292.5) return 'W';
    return 'NW';
  }

  String? get formattedSunrise {
    if (sunrise == null) return null;
    final date = DateTime.fromMillisecondsSinceEpoch(sunrise! * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String? get formattedSunset {
    if (sunset == null) return null;
    final date = DateTime.fromMillisecondsSinceEpoch(sunset! * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get location => '$cityName, $country';

  @override
  List<Object?> get props => [
        cityName,
        country,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        windDegree,
        pressure,
        description,
        iconCode,
        conditionId,
        lastUpdated,
      ];

  Weather copyWith({
    String? cityName,
    String? country,
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    int? windDegree,
    int? pressure,
    String? description,
    String? iconCode,
    int? conditionId,
    double? tempMin,
    double? tempMax,
    int? visibility,
    int? sunrise,
    int? sunset,
    int? cloudiness,
    DateTime? lastUpdated,
  }) {
    return Weather(
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDegree: windDegree ?? this.windDegree,
      pressure: pressure ?? this.pressure,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      conditionId: conditionId ?? this.conditionId,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      visibility: visibility ?? this.visibility,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      cloudiness: cloudiness ?? this.cloudiness,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}