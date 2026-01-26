import 'package:meteo/core/constants/api_constants.dart';
import 'package:meteo/data/datasources/local/hive_service.dart';
import 'package:meteo/data/models/city_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';

abstract class LocalDataSource {
  Future<WeatherModel?> getCachedWeather(String cityName);
  Future<void> cacheWeather(WeatherModel weather);
  Future<List<WeatherModel>> getAllCachedWeather();
  Future<void> clearWeatherCache();

  Future<List<CityModel>> getFavoriteCities();
  Future<void> addFavoriteCity(CityModel city);
  Future<void> removeFavoriteCity(String cityId);
  Future<bool> isCityFavorite(String cityId);
  Future<List<CityModel>> getRecentCities();

  Future<List<ForecastModel>?> getCachedForecast(String cityId);
  Future<void> cacheForecast(String cityId, List<ForecastModel> forecast);
  Future<void> clearForecastCache();

  Future<String?> getLanguage();
  Future<void> saveLanguage(String language);
  
  Future<bool?> getDarkMode();
  Future<void> saveDarkMode(bool isDarkMode);
  
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<WeatherModel?> getCachedWeather(String cityName) async {
    try {
      final weather = await HiveService.getWeather(cityName);
      if (weather != null) {
        final age = DateTime.now().difference(weather.lastUpdated);
        if (age.inMinutes < ApiConstants.weatherCacheDuration) {
          return weather;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cached weather: $e');
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    try {
      await HiveService.saveWeather(weather);
    } catch (e) {
      throw Exception('Failed to cache weather: $e');
    }
  }

  @override
  Future<List<WeatherModel>> getAllCachedWeather() async {
    try {
      return await HiveService.getAllWeather();
    } catch (e) {
      throw Exception('Failed to get all cached weather: $e');
    }
  }

  @override
  Future<void> clearWeatherCache() async {
    try {
      // CORRECTION : Utilisez la méthode correcte pour vider la boîte météo
      // Option 1 : Si vous avez une méthode clearAllWeather()
      await HiveService.clearAllWeather();
      // OU Option 2 : Ouvrir la boîte et la vider
      // final box = await HiveService.openBox<WeatherModel>('weather_cache');
      // await box.clear();
    } catch (e) {
      throw Exception('Failed to clear weather cache: $e');
    }
  }

  @override
  Future<List<CityModel>> getFavoriteCities() async {
    try {
      return await HiveService.getFavoriteCities();
    } catch (e) {
      throw Exception('Failed to get favorite cities: $e');
    }
  }

  @override
  Future<void> addFavoriteCity(CityModel city) async {
    try {
      await HiveService.saveFavoriteCity(city);
    } catch (e) {
      throw Exception('Failed to add favorite city: $e');
    }
  }

  @override
  Future<void> removeFavoriteCity(String cityId) async {
    try {
      await HiveService.removeFavoriteCity(cityId);
    } catch (e) {
      throw Exception('Failed to remove favorite city: $e');
    }
  }

  @override
  Future<bool> isCityFavorite(String cityId) async {
    try {
      return await HiveService.isCityFavorite(cityId);
    } catch (e) {
      throw Exception('Failed to check if city is favorite: $e');
    }
  }

  @override
  Future<List<CityModel>> getRecentCities() async {
    try {
      final box = await HiveService.openBox<CityModel>('recent_cities');
      final cities = box.values.toList();
      
      // Trier par date de recherche (les plus récentes d'abord)
      cities.sort((a, b) {
        if (a.lastSearched == null && b.lastSearched == null) return 0;
        if (a.lastSearched == null) return 1;
        if (b.lastSearched == null) return -1;
        return b.lastSearched!.compareTo(a.lastSearched!);
      });
      
      // Retourner les 10 plus récentes
      return cities.take(10).toList();
    } catch (e) {
      throw Exception('Failed to get recent cities: $e');
    }
  }

  @override
  Future<List<ForecastModel>?> getCachedForecast(String cityId) async {
    try {
      final forecast = await HiveService.getForecast(cityId);
      if (forecast != null && forecast.isNotEmpty) {
        final age = DateTime.now().difference(forecast.first.dateTime);
        if (age.inMinutes < ApiConstants.forecastCacheDuration) {
          return forecast;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cached forecast: $e');
    }
  }

  @override
  Future<void> cacheForecast(String cityId, List<ForecastModel> forecast) async {
    try {
      await HiveService.saveForecast(cityId, forecast);
    } catch (e) {
      throw Exception('Failed to cache forecast: $e');
    }
  }

  @override
  Future<void> clearForecastCache() async {
    try {
      // CORRECTION : Utilisez la méthode correcte pour vider la boîte de prévisions
      // Option 1 : Si vous avez une méthode clearAllForecasts()
      await HiveService.clearAllForecasts();
      // OU Option 2 : Ouvrir la boîte et la vider
      // final box = await HiveService.openBox<List<ForecastModel>>('forecast_cache');
      // await box.clear();
    } catch (e) {
      throw Exception('Failed to clear forecast cache: $e');
    }
  }

  @override
  Future<String?> getLanguage() async {
    try {
      return await HiveService.getSetting<String>('language');
    } catch (e) {
      throw Exception('Failed to get language: $e');
    }
  }

  @override
  Future<void> saveLanguage(String language) async {
    try {
      await HiveService.saveSetting('language', language);
    } catch (e) {
      throw Exception('Failed to save language: $e');
    }
  }

  @override
  Future<bool?> getDarkMode() async {
    try {
      return await HiveService.getSetting<bool>('dark_mode');
    } catch (e) {
      throw Exception('Failed to get dark mode: $e');
    }
  }

  @override
  Future<void> saveDarkMode(bool isDarkMode) async {
    try {
      await HiveService.saveSetting('dark_mode', isDarkMode);
    } catch (e) {
      throw Exception('Failed to save dark mode: $e');
    }
  }

  @override
  Future<bool> isFirstLaunch() async {
    try {
      final launched = await HiveService.getSetting<bool>('first_launch');
      return launched == null || launched == true;
    } catch (e) {
      throw Exception('Failed to check first launch: $e');
    }
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    try {
      await HiveService.saveSetting('first_launch', false);
    } catch (e) {
      throw Exception('Failed to set first launch completed: $e');
    }
  }

  Future<void> cleanup() async {
    try {
      await HiveService.cleanupExpiredData();
    } catch (e) {
      throw Exception('Failed to cleanup data: $e');
    }
  }

}