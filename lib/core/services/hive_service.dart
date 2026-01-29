import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meteo/data/models/favorite_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:flutter/foundation.dart';

class HiveService {
  static Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      await initForMobile();
    }
    
    Hive.registerAdapter(WeatherModelAdapter());
    Hive.registerAdapter(FavoriteModelAdapter());
    Hive.registerAdapter(ForecastModelAdapter());
    
    await Hive.openBox<WeatherModel>('weather_cache');
    await Hive.openBox<FavoriteModel>('favorites');
    await Hive.openBox('settings');
  }
  
  static Future<void> initForMobile() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }
  
  static Future<void> saveWeatherCache(WeatherModel weather) async {
    final box = Hive.box<WeatherModel>('weather_cache');
    await box.put('current', weather);
  }
  
  static WeatherModel? getWeatherCache() {
    final box = Hive.box<WeatherModel>('weather_cache');
    return box.get('current');
  }
}