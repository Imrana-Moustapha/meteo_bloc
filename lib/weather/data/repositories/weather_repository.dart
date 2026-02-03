import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo/core/config/api_config.dart';
import 'package:meteo/forecast/data/models/forecast_model.dart';
import 'package:meteo/weather/data/models/weather_model.dart';

class WeatherRepository {
  static const String defaultCity = 'Niger';
  
  Future<WeatherModel> getCurrentWeather({String? cityName}) async {
    final city = cityName ?? defaultCity;
    
    final response = await http.get(Uri.parse(ApiConfig.currentWeatherUrl(city)));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      return WeatherModel(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        condition: data['weather'][0]['description'],
        icon: data['weather'][0]['icon'],
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'].toDouble(),
        lastUpdated: DateTime.now(),
      );
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }
  
  Future<List<ForecastModel>> getForecast({String? cityName}) async {
    final city = cityName ?? defaultCity;
    
    final response = await http.get(Uri.parse(ApiConfig.forecastUrl(city)));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      
      return list.map((item) {
        return ForecastModel(
          date: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          temp: item['main']['temp'].toDouble(),
          tempMin: item['main']['temp_min'].toDouble(),
          tempMax: item['main']['temp_max'].toDouble(),
          condition: item['weather'][0]['description'],
          icon: item['weather'][0]['icon'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}