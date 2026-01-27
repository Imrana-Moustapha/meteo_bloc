import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 1)
class WeatherModel {
  @HiveField(0)
  final String cityName;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final String condition;
  
  @HiveField(3)
  final String icon;
  
  @HiveField(4)
  final int humidity;
  
  @HiveField(5)
  final double windSpeed;
  
  @HiveField(6)
  final DateTime lastUpdated;
  
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });
}