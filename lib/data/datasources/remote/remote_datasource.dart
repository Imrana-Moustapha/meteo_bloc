import 'package:meteo/core/constants/api_constants.dart';
import 'package:meteo/data/datasources/remote/weather_api_service.dart';
import 'package:meteo/data/models/city_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
  Future<List<ForecastModel>> getForecast(String cityName);
  Future<List<ForecastModel>> getDailyForecast(String cityName, int days);
  Future<List<CityModel>> searchCities(String query);
  Future<List<CityModel>> reverseGeocode(double lat, double lon);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final WeatherApiService weatherApiService;

  RemoteDataSourceImpl({required this.weatherApiService});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      return await weatherApiService.getCurrentWeather(
        cityName: cityName,
        language: ApiConstants.lang,
        units: ApiConstants.units,
      );
    } catch (e) {
      throw Exception('Failed to fetch current weather: $e');
    }
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      return await weatherApiService.getWeatherByCoordinates(
        lat: lat,
        lon: lon,
        language: ApiConstants.lang,
        units: ApiConstants.units,
      );
    } catch (e) {
      throw Exception('Failed to fetch weather by coordinates: $e');
    }
  }

  @override
  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      return await weatherApiService.getForecast(
        cityName: cityName,
        language: ApiConstants.lang,
        units: ApiConstants.units,
        count: 40, // 5 jours
      );
    } catch (e) {
      throw Exception('Failed to fetch forecast: $e');
    }
  }

  @override
  Future<List<ForecastModel>> getDailyForecast(String cityName, int days) async {
    try {
      return await weatherApiService.getDailyForecast(
        cityName: cityName,
        language: ApiConstants.lang,
        units: ApiConstants.units,
        days: days,
      );
    } catch (e) {
      throw Exception('Failed to fetch daily forecast: $e');
    }
  }

  @override
  Future<List<CityModel>> searchCities(String query) async {
    try {
      return await weatherApiService.searchCities(
        query: query,
        limit: 10,
        language: ApiConstants.lang,
      );
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }

  @override
  Future<List<CityModel>> reverseGeocode(double lat, double lon) async {
    try {
      return await weatherApiService.reverseGeocode(
        lat: lat,
        lon: lon,
        limit: 1,
        language: ApiConstants.lang,
      );
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }

  Future<void> close() async {
    await weatherApiService.close();
  }
}