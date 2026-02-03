import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 2)
class FavoriteModel {
  @HiveField(0)
  final String cityId;
  
  @HiveField(1)
  final String cityName;
  
  @HiveField(2)
  final String country;
  
  @HiveField(3)
  final double lat;
  
  @HiveField(4)
  final double lon;
  
  @HiveField(5)
  final DateTime addedAt;
  
  FavoriteModel({
    required this.cityId,
    required this.cityName,
    required this.country,
    required this.lat,
    required this.lon,
    required this.addedAt,
  });
}