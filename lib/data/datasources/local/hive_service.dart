import 'package:hive/hive.dart';
import 'package:meteo/core/constants/app_constants.dart';
import 'package:meteo/data/models/city_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveService {
  static String? get weatherBox => null;

  static Future<void> init() async {
    final appDocumentDirectory = await path_provider
        .getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Enregistrement des adaptateurs
    Hive.registerAdapter(WeatherModelAdapter());
    Hive.registerAdapter(CityModelAdapter());
    Hive.registerAdapter(ForecastModelAdapter());
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  static Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  static Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  // Méthodes pour WeatherModel
  static Future<void> saveWeather(WeatherModel weather) async {
    final box = await openBox<WeatherModel>(AppConstants.weatherBox);
    await box.put(weather.cityName.toLowerCase(), weather);
  }

  static Future<WeatherModel?> getWeather(String cityName) async {
    final box = await openBox<WeatherModel>(AppConstants.weatherBox);
    return box.get(cityName.toLowerCase());
  }

  static Future<List<WeatherModel>> getAllWeather() async {
    final box = await openBox<WeatherModel>(AppConstants.weatherBox);
    return box.values.toList();
  }

  static Future<void> deleteWeather(String cityName) async {
    final box = await openBox<WeatherModel>(AppConstants.weatherBox);
    await box.delete(cityName.toLowerCase());
  }

  // Méthodes pour CityModel (favoris)
  static Future<void> saveFavoriteCity(CityModel city) async {
    final box = await openBox<CityModel>(AppConstants.favoritesBox);
    await box.put(city.id, city.copyWith(isFavorite: true));
  }

  static Future<void> removeFavoriteCity(String cityId) async {
    final box = await openBox<CityModel>(AppConstants.favoritesBox);
    await box.delete(cityId);
  }

  static Future<List<CityModel>> getFavoriteCities() async {
    final box = await openBox<CityModel>(AppConstants.favoritesBox);
    return box.values.where((city) => city.isFavorite).toList();
  }

  static Future<bool> isCityFavorite(String cityId) async {
    final box = await openBox<CityModel>(AppConstants.favoritesBox);
    final city = box.get(cityId);
    return city?.isFavorite ?? false;
  }

  // Méthodes pour ForecastModel
  static Future<void> saveForecast(
    String cityId,
    List<ForecastModel> forecast,
  ) async {
    final box = await openBox<List<ForecastModel>>(AppConstants.weatherBox);
    await box.put('${cityId}_forecast', forecast);
  }

  static Future<List<ForecastModel>?> getForecast(String cityId) async {
    final box = await openBox<List<ForecastModel>>(AppConstants.weatherBox);
    return box.get('${cityId}_forecast');
  }

  // Méthodes génériques pour les paramètres
  static Future<void> saveSetting<T>(String key, T value) async {
    final box = await openBox<T>(AppConstants.settingsBox);
    await box.put(key, value);
  }

  static Future<T?> getSetting<T>(String key) async {
    final box = await openBox<T>(AppConstants.settingsBox);
    return box.get(key);
  }

  static Future<bool> hasSetting(String key) async {
    final box = await openBox<dynamic>(AppConstants.settingsBox);
    return box.containsKey(key);
  }

  static Future<void> deleteSetting(String key) async {
    final box = await openBox<dynamic>(AppConstants.settingsBox);
    await box.delete(key);
  }

  // Nettoyage des données expirées
  static Future<void> cleanupExpiredData({
    Duration weatherExpiration = const Duration(minutes: 10),
    Duration forecastExpiration = const Duration(hours: 1),
  }) async {
    final now = DateTime.now();

    // Nettoyer les données météo expirées
    final weatherBox = await openBox<WeatherModel>(AppConstants.weatherBox);
    for (final key in weatherBox.keys) {
      final weather = weatherBox.get(key);
      if (weather != null) {
        final age = now.difference(weather.lastUpdated);
        if (age > weatherExpiration) {
          await weatherBox.delete(key);
        }
      }
    }

    // Nettoyer les prévisions expirées
    final forecastBox = await openBox<List<ForecastModel>>(
      AppConstants.weatherBox,
    );
    for (final key in forecastBox.keys) {
      final forecasts = forecastBox.get(key);
      if (forecasts != null && forecasts.isNotEmpty) {
        final firstForecast = forecasts.first;
        final age = now.difference(firstForecast.dateTime);
        if (age > forecastExpiration) {
          await forecastBox.delete(key);
        }
      }
    }

    // Nettoyer les villes non favorites et non recherchées récemment
    final favoritesBox = await openBox<CityModel>(AppConstants.favoritesBox);
    final monthAgo = now.subtract(const Duration(days: 30));

    for (final key in favoritesBox.keys) {
      final city = favoritesBox.get(key);
      if (city != null && !city.isFavorite) {
        if (city.lastSearched == null ||
            city.lastSearched!.isBefore(monthAgo)) {
          await favoritesBox.delete(key);
        }
      }
    }
  }

  // Sauvegarde et restauration
  static Future<void> backupData() async {
    // Implémentation pour sauvegarder les données
    // (pourrait être utilisé pour exporter les favoris)
  }

  static Future<void> restoreData() async {
    // Implémentation pour restaurer les données
  }

  // Dans votre HiveService, ajoutez ces méthodes :
  static Future<void> clearAllWeather() async {
    final box = await openBox<WeatherModel>('weather_cache');
    await box.clear();
  }

  static Future<void> clearAllForecasts() async {
    final box = await openBox<List<ForecastModel>>('forecast_cache');
    await box.clear();
  }
}
