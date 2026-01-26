import 'dart:convert';
import 'package:meteo/core/constants/api_constants.dart';
import 'package:meteo/core/utils/extensions.dart';
import 'package:meteo/core/utils/helpers.dart';
import 'package:meteo/data/models/city_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:http/http.dart' as http;
class WeatherApiService {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  WeatherApiService({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
  });

  Future<WeatherModel> getCurrentWeather({
    required String cityName,
    String? language,
    String? units,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final params = {
        'q': cityName,
        'appid': apiKey,
        'units': units ?? ApiConstants.units,
        'lang': language ?? ApiConstants.lang,
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.currentWeather}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to get current weather: $e');
    }
  }

  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lon,
    String? language,
    String? units,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final params = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': apiKey,
        'units': units ?? ApiConstants.units,
        'lang': language ?? ApiConstants.lang,
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.currentWeather}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to get weather by coordinates: $e');
    }
  }

  Future<List<ForecastModel>> getForecast({
    required String cityName,
    String? language,
    String? units,
    int? count,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final params = {
        'q': cityName,
        'appid': apiKey,
        'units': units ?? ApiConstants.units,
        'lang': language ?? ApiConstants.lang,
        'cnt': count?.toString() ?? '40', // 5 jours * 8 = 40 prévisions
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.forecast}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body);
        final list = data['list'] as List;
        
        return list
            .map<ForecastModel>((json) => ForecastModel.fromHourlyJson(json))
            .toList();
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to get forecast: $e');
    }
  }

  Future<List<ForecastModel>> getDailyForecast({
    required String cityName,
    String? language,
    String? units,
    int days = 7,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      // Note: OpenWeatherMap n'a pas d'endpoint dédié aux prévisions quotidiennes
      // Nous utilisons l'endpoint standard et regroupons par jour
      final params = {
        'q': cityName,
        'appid': apiKey,
        'units': units ?? ApiConstants.units,
        'lang': language ?? ApiConstants.lang,
        'cnt': (days * 8).toString(), // 8 prévisions par jour
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.forecast}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body);
        final list = data['list'] as List;
        
        // Convertir toutes les prévisions horaires
        final hourlyForecasts = list
            .map<ForecastModel>((json) => ForecastModel.fromHourlyJson(json))
            .toList();
        
        // Grouper par jour et prendre la prévision de midi pour chaque jour
        final dailyForecasts = <ForecastModel>[];
        final groupedByDay = <String, List<ForecastModel>>{};
        
        for (final forecast in hourlyForecasts) {
          final dayKey = forecast.dateTime.format('yyyy-MM-dd');
          if (!groupedByDay.containsKey(dayKey)) {
            groupedByDay[dayKey] = [];
          }
          groupedByDay[dayKey]!.add(forecast);
        }
        
        // Pour chaque jour, prendre la prévision la plus proche de 12h
        for (final dayKey in groupedByDay.keys.take(days)) {
          final dayForecasts = groupedByDay[dayKey]!;
          dayForecasts.sort((a, b) {
            final aDiff = (a.dateTime.hour - 12).abs();
            final bDiff = (b.dateTime.hour - 12).abs();
            return aDiff.compareTo(bDiff);
          });
          
          if (dayForecasts.isNotEmpty) {
            dailyForecasts.add(dayForecasts.first);
          }
        }
        
        return dailyForecasts;
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to get daily forecast: $e');
    }
  }

  Future<List<CityModel>> searchCities({
    required String query,
    int limit = 5,
    String? language,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final params = {
        'q': query,
        'limit': limit.toString(),
        'appid': apiKey,
        'lang': language ?? ApiConstants.lang,
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.searchCities}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body) as List;
        
        return data
            .map<CityModel>((json) => CityModel.fromSearchJson(json))
            .toList();
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }

  Future<List<CityModel>> reverseGeocode({
    required double lat,
    required double lon,
    int limit = 1,
    String? language,
  }) async {
    try {
      final isConnected = await Helpers.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final params = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'limit': limit.toString(),
        'appid': apiKey,
        'lang': language ?? ApiConstants.lang,
      };

      final uri = Uri.parse('$baseUrl${ApiConstants.reverseGeocoding}').replace(
        queryParameters: params,
      );

      final response = await client
          .get(uri)
          .timeout(ApiConstants.timeout)
          .catchError((error) {
        throw Exception('Network error: $error');
      });

      if (response.statusCode == ApiConstants.successCode) {
        final data = json.decode(response.body) as List;
        
        return data
            .map<CityModel>((json) => CityModel.fromSearchJson(json))
            .toList();
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }

  Exception _handleError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return Exception('Bad request');
      case 401:
        return Exception('Invalid API key');
      case 404:
        return Exception('City not found');
      case 429:
        return Exception('Rate limit exceeded');
      case 500:
      case 502:
      case 503:
      case 504:
        return Exception('Server error');
      default:
        return Exception('Unknown error: $statusCode');
    }
  }

  Future<void> close() async {
    client.close();
  }
}