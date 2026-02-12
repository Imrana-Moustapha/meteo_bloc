import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:meteo/core/config/api_config.dart';
import 'package:meteo/forecast/data/models/forecast_model.dart';
import 'package:meteo/weather/data/models/weather_model.dart';

class WeatherRepository {
  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> getCurrentWeather({String? cityName}) async {
    String url;

    if (cityName == null || cityName.isEmpty) {
      Position? position = await _getCurrentPosition();
      
      if (position != null) {
        url = ApiConfig.currentWeatherByLocationUrl(position.latitude, position.longitude);
      } else {
        throw Exception('GPS_REQUIRED');
      }
    } else {
      url = ApiConfig.currentWeatherUrl(cityName);
    }

    final response = await http.get(Uri.parse(url));

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
      throw Exception('CITY_NOT_FOUND');
    }
  }

  Future<List<ForecastModel>> getForecast({String? cityName}) async {
    String url;

    if (cityName == null || cityName.isEmpty) {
      Position? position = await _getCurrentPosition();
      
      if (position != null) {
        url = ApiConfig.forecastByLocationUrl(position.latitude, position.longitude);
      } else {
        throw Exception('GPS_REQUIRED');
      }
    } else {
      url = ApiConfig.forecastUrl(cityName);
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      
      return list.map((item) => ForecastModel(
        date: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
        temp: item['main']['temp'].toDouble(),
        tempMin: item['main']['temp_min'].toDouble(),
        tempMax: item['main']['temp_max'].toDouble(),
        condition: item['weather'][0]['description'],
        icon: item['weather'][0]['icon'],
      )).toList();
    } else {
      throw Exception('FORECAST_ERROR');
    }
  }
}