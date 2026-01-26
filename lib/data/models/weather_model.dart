import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 1)
class WeatherModel extends Equatable {
  @HiveField(0)
  final String cityName;
  
  @HiveField(1)
  final String country;
  
  @HiveField(2)
  final double temperature;
  
  @HiveField(3)
  final double feelsLike;
  
  @HiveField(4)
  final int humidity;
  
  @HiveField(5)
  final double windSpeed;
  
  @HiveField(6)
  final int windDegree;
  
  @HiveField(7)
  final int pressure;
  
  @HiveField(8)
  final String description;
  
  @HiveField(9)
  final String iconCode;
  
  @HiveField(10)
  final int conditionId;
  
  @HiveField(11)
  final double? tempMin;
  
  @HiveField(12)
  final double? tempMax;
  
  @HiveField(13)
  final int? visibility;
  
  @HiveField(14)
  final int? sunrise;
  
  @HiveField(15)
  final int? sunset;
  
  @HiveField(16)
  final int? cloudiness;
  
  @HiveField(17)
  final DateTime lastUpdated;

  const WeatherModel({
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

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = (json['weather'] as List).first;
    final main = json['main'];
    final wind = json['wind'];
    final sys = json['sys'];
    final clouds = json['clouds'];

    return WeatherModel(
      cityName: json['name'],
      country: sys['country'],
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'],
      windSpeed: (wind['speed'] as num).toDouble(),
      windDegree: wind['deg'] ?? 0,
      pressure: main['pressure'],
      description: weather['description'],
      iconCode: weather['icon'],
      conditionId: weather['id'],
      tempMin: (main['temp_min'] as num?)?.toDouble(),
      tempMax: (main['temp_max'] as num?)?.toDouble(),
      visibility: json['visibility'] as int?,
      sunrise: sys['sunrise'],
      sunset: sys['sunset'],
      cloudiness: clouds['all'],
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDegree': windDegree,
      'pressure': pressure,
      'description': description,
      'iconCode': iconCode,
      'conditionId': conditionId,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'visibility': visibility,
      'sunrise': sunrise,
      'sunset': sunset,
      'cloudiness': cloudiness,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Helper pour obtenir l'URL de l'icône
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  // Helper pour formater la température
  String get formattedTemperature => '${temperature.toStringAsFixed(1)}°C';

  // Helper pour obtenir la direction du vent
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

  // Helper pour obtenir l'heure formatée du lever/coucher du soleil
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

  WeatherModel copyWith({
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
    return WeatherModel(
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