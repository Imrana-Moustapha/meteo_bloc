// ignore: file_names
import 'dart:convert';
import 'package:flutter/services.dart';

class Environment {
  static late Map<String, dynamic> _env;

  static Future<void> load() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/env.json');
      _env = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load environment variables: $e');
    }
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _env[key]?.toString() ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    final value = _env[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    final value = _env[key];
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = _env[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // Getters pour les variables spécifiques
  static String get apiKey => getString('OPEN_WEATHER_API_KEY');
  static String get baseUrl => getString('OPEN_WEATHER_BASE_URL');
  static bool get isDebug => getBool('DEBUG_MODE');
  static String get appName => getString('APP_NAME');
  static int get weatherCacheDuration => getInt('WEATHER_CACHE_DURATION');
  static int get forecastCacheDuration => getInt('FORECAST_CACHE_DURATION');
  static int get apiTimeout => getInt('API_TIMEOUT');
  static int get maxRetries => getInt('MAX_API_RETRIES');
}