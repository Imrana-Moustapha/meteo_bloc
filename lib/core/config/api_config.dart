import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.openweathermap.org/data/2.5';

  // --- (par ville) ---

  static String currentWeatherUrl(String city) {
    return '$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=fr';
  }

  static String forecastUrl(String city) {
    return '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=fr&cnt=5';
  }

  // --- (par position GPS) ---

  static String currentWeatherByLocationUrl(double lat, double lon) {
    return '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr';
  }

  static String forecastByLocationUrl(double lat, double lon) {
    return '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr&cnt=5';
  }
  
}
