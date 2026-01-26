import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/domain/entities/forecast.dart';
import 'package:meteo/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String cityName);
  Future<Weather> getWeatherByCoordinates(double lat, double lon);
  Future<List<Forecast>> getForecast(String cityName);
  Future<List<Forecast>> getDailyForecast(String cityName, int days);
  Future<List<City>> searchCities(String query);
  Future<List<City>> reverseGeocode(double lat, double lon);
  
  Future<List<City>> getFavoriteCities();
  Future<void> addFavoriteCity(City city);
  Future<void> removeFavoriteCity(String cityId);
  Future<bool> isCityFavorite(String cityId);
  Future<List<City>> getRecentCities();
  
  Future<String?> getLanguage();
  Future<void> saveLanguage(String language);
  
  Future<bool?> getDarkMode();
  Future<void> saveDarkMode(bool isDarkMode);
  
  Future<void> clearCache();
}