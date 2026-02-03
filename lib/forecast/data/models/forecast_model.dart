import 'package:hive/hive.dart';

part 'forecast_model.g.dart';

@HiveType(typeId: 3)
class ForecastModel {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double temp;
  
  @HiveField(2)
  final double tempMin;
  
  @HiveField(3)
  final double tempMax;
  
  @HiveField(4)
  final String condition;
  
  @HiveField(5)
  final String icon;
  
  ForecastModel({
    required this.date,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.icon,
  });
}