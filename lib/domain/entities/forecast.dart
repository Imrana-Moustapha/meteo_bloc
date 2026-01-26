import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String iconCode;
  final int conditionId;
  final double? tempMin;
  final double? tempMax;
  final int? pop;
  final int? cloudiness;
  final double? rainVolume;
  final double? snowVolume;

  const Forecast({
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

  String get dayOfWeek {
    final days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    return days[dateTime.weekday % 7];
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:00';
  }

  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get formattedTemperature => '${temperature.toStringAsFixed(1)}°C';

  String get formattedPop {
    if (pop == null) return '0%';
    return '${pop}%';
  }

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

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

  Forecast copyWith({
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
    return Forecast(
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