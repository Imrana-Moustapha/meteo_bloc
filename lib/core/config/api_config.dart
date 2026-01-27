import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get apiKey {
    return dotenv.env['WEATHER_API_KEY'] ?? '';
  }
  
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'https://api.openweathermap.org/data/2.5';
  }
  
  static String currentWeatherUrl(String city) {
    return '$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=fr';
  }
  
  static String forecastUrl(String city) {
    return '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=fr&cnt=5';
  }
}