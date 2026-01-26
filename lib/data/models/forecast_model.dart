import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'forecast_model.g.dart';

@HiveType(typeId: 3)
class ForecastModel extends Equatable {
  @HiveField(0)
  final DateTime dateTime;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final double feelsLike;
  
  @HiveField(3)
  final int humidity;
  
  @HiveField(4)
  final double windSpeed;
  
  @HiveField(5)
  final int pressure;
  
  @HiveField(6)
  final String description;
  
  @HiveField(7)
  final String iconCode;
  
  @HiveField(8)
  final int conditionId;
  
  @HiveField(9)
  final double? tempMin;
  
  @HiveField(10)
  final double? tempMax;
  
  @HiveField(11)
  final int? pop; // Probability of Precipitation
  
  @HiveField(12)
  final int? cloudiness;
  
  @HiveField(13)
  final double? rainVolume;
  
  @HiveField(14)
  final double? snowVolume;

  const ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.conditionId,
    this.tempMin,
    this.tempMax,
    this.pop,
    this.cloudiness,
    this.rainVolume,
    this.snowVolume,
  });

  // Pour la prévision horaire
  factory ForecastModel.fromHourlyJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = (json['weather'] as List).first;
    final wind = json['wind'];
    final clouds = json['clouds'];
    final rain = json['rain'];
    final snow = json['snow'];

    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'],
      windSpeed: (wind['speed'] as num).toDouble(),
      pressure: main['pressure'],
      description: weather['description'],
      iconCode: weather['icon'],
      conditionId: weather['id'],
      tempMin: (main['temp_min'] as num?)?.toDouble(),
      tempMax: (main['temp_max'] as num?)?.toDouble(),
      pop: (json['pop'] as num?)?.toDouble().round(),
      cloudiness: clouds['all'],
      rainVolume: rain != null ? (rain['1h'] as num?)?.toDouble() : null,
      snowVolume: snow != null ? (snow['1h'] as num?)?.toDouble() : null,
    );
  }

  // Pour la prévision quotidienne
  factory ForecastModel.fromDailyJson(Map<String, dynamic> json) {
    final temp = json['temp'];
    final feelsLike = json['feels_like'];
    final weather = (json['weather'] as List).first;

    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (temp['day'] as num).toDouble(),
      feelsLike: (feelsLike['day'] as num).toDouble(),
      humidity: json['humidity'],
      windSpeed: (json['wind_speed'] as num).toDouble(),
      pressure: json['pressure'],
      description: weather['description'],
      iconCode: weather['icon'],
      conditionId: weather['id'],
      tempMin: (temp['min'] as num?)?.toDouble(),
      tempMax: (temp['max'] as num?)?.toDouble(),
      pop: (json['pop'] as num?)?.toDouble().round(),
      cloudiness: json['clouds'],
      rainVolume: (json['rain'] as num?)?.toDouble(),
      snowVolume: (json['snow'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'description': description,
      'iconCode': iconCode,
      'conditionId': conditionId,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'pop': pop,
      'cloudiness': cloudiness,
      'rainVolume': rainVolume,
      'snowVolume': snowVolume,
    };
  }

  // Helper pour obtenir le jour de la semaine
  String get dayOfWeek {
    final days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    return days[dateTime.weekday % 7];
  }

  // Helper pour obtenir l'heure formatée
  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:00';
  }

  // Helper pour obtenir la date formatée
  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // Helper pour obtenir l'URL de l'icône
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  // Helper pour formater la température
  String get formattedTemperature => '${temperature.toStringAsFixed(1)}°C';

  // Helper pour obtenir la probabilité de précipitation formatée
  String get formattedPop {
    if (pop == null) return '0%';
    return '${pop}%';
  }

  // Helper pour vérifier si c'est la journée actuelle
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  // Helper pour vérifier si c'est la nuit (basé sur l'heure)
  bool get isNightTime {
    final hour = dateTime.hour;
    return hour < 6 || hour > 18;
  }

  @override
  List<Object?> get props => [
        dateTime,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        pressure,
        description,
        iconCode,
        conditionId,
      ];

  ForecastModel copyWith({
    DateTime? dateTime,
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    int? pressure,
    String? description,
    String? iconCode,
    int? conditionId,
    double? tempMin,
    double? tempMax,
    int? pop,
    int? cloudiness,
    double? rainVolume,
    double? snowVolume,
  }) {
    return ForecastModel(
      dateTime: dateTime ?? this.dateTime,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      pressure: pressure ?? this.pressure,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      conditionId: conditionId ?? this.conditionId,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      pop: pop ?? this.pop,
      cloudiness: cloudiness ?? this.cloudiness,
      rainVolume: rainVolume ?? this.rainVolume,
      snowVolume: snowVolume ?? this.snowVolume,
    );
  }
}