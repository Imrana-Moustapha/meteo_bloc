import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // URLs de base
  static final String openWeatherBaseUrl = dotenv.env['OPEN_WEATHER_BASE_URL'] ?? 'https://api.openweathermap.org';
  static final String weatherApiBaseUrl = dotenv.env['WEATHER_API_BASE_URL'] ?? 'https://api.weatherapi.com/v1';
  
  // Clés API
  static final String openWeatherApiKey = dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';
  static final String weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  
  // Endpoints
  static const String currentWeather = '/data/2.5/weather';
  static const String forecast = '/data/2.5/forecast';
  static const String hourlyForecast = '/data/2.5/forecast/hourly';
  static const String dailyForecast = '/data/2.5/forecast/daily';
  static const String searchCities = '/geo/1.0/direct';
  static const String reverseGeocoding = '/geo/1.0/reverse';
  
  // Paramètres par défaut
  static const String units = 'metric';
  static const String lang = 'fr';
  
  // Durées de cache (en minutes)
  static final int weatherCacheDuration = int.tryParse(dotenv.env['WEATHER_CACHE_DURATION'] ?? '10') ?? 10;
  static final int forecastCacheDuration = int.tryParse(dotenv.env['FORECAST_CACHE_DURATION'] ?? '60') ?? 60;
  
  // Configuration réseau
  static final int maxRetries = int.tryParse(dotenv.env['MAX_API_RETRIES'] ?? '3') ?? 3;
  static final Duration timeout = Duration(seconds: int.tryParse(dotenv.env['API_TIMEOUT'] ?? '10') ?? 10);
  
  // Statut de l'API
  static const int successCode = 200;
  static const int notFoundCode = 404;
  static const int unauthorizedCode = 401;
  static const int rateLimitCode = 429;
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}