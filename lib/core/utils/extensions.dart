import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get translatedWeatherDescription {
    final descriptions = {
      // Clear
      'clear sky': 'Ciel dégagé',
      // Clouds
      'few clouds': 'Peu nuageux',
      'scattered clouds': 'Nuages épars',
      'broken clouds': 'Nuages fragmentés',
      'overcast clouds': 'Ciel couvert',
      // Rain
      'light rain': 'Pluie légère',
      'moderate rain': 'Pluie modérée',
      'heavy intensity rain': 'Forte pluie',
      'very heavy rain': 'Pluie très forte',
      'extreme rain': 'Pluie extrême',
      'freezing rain': 'Pluie verglaçante',
      'light intensity shower rain': 'Averses légères',
      'shower rain': 'Averses',
      'heavy intensity shower rain': 'Forte averses',
      'ragged shower rain': 'Averses irrégulières',
      // Drizzle
      'light intensity drizzle': 'Bruine légère',
      'drizzle': 'Bruine',
      'heavy intensity drizzle': 'Forte bruine',
      'shower drizzle': 'Averses de bruine',
      // Thunderstorm
      'thunderstorm with light rain': 'Orage avec pluie légère',
      'thunderstorm with rain': 'Orage avec pluie',
      'thunderstorm with heavy rain': 'Orage avec forte pluie',
      'light thunderstorm': 'Orage léger',
      'thunderstorm': 'Orage',
      'heavy thunderstorm': 'Fort orage',
      'ragged thunderstorm': 'Orage irrégulier',
      // Snow
      'light snow': 'Neige légère',
      'snow': 'Neige',
      'heavy snow': 'Forte neige',
      'sleet': 'Neige fondue',
      'light shower sleet': 'Averses de neige fondue légère',
      'shower sleet': 'Averses de neige fondue',
      'light rain and snow': 'Pluie et neige légères',
      'rain and snow': 'Pluie et neige',
      'light shower snow': 'Averses de neige légères',
      'shower snow': 'Averses de neige',
      'heavy shower snow': 'Forte averses de neige',
      // Atmosphere
      'mist': 'Brume',
      'smoke': 'Fumée',
      'haze': 'Brume sèche',
      'sand/dust whirls': 'Tourbillons de sable/poussière',
      'fog': 'Brouillard',
      'sand': 'Sable',
      'dust': 'Poussière',
      'volcanic ash': 'Cendre volcanique',
      'squalls': 'Rafales',
      'tornado': 'Tornade',
    };

    return descriptions[toLowerCase()] ?? capitalize();
  }

  String get translatedToArabic {
    final arabicTranslations = {
      'clear sky': 'سماء صافية',
      'few clouds': 'قليل من السحب',
      'scattered clouds': 'سحب متفرقة',
      'broken clouds': 'سحب متكسرة',
      'overcast clouds': 'غيوم',
      'light rain': 'مطر خفيف',
      'moderate rain': 'مطر معتدل',
      'heavy intensity rain': 'مطر شديد',
      'very heavy rain': 'مطر غزير',
      'extreme rain': 'مطر قوي',
      'freezing rain': 'مطر متجمد',
    };

    return arabicTranslations[toLowerCase()] ?? this;
  }
}

extension DateTimeExtensions on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String get dayName {
    return DateFormat('EEEE', 'fr_FR').format(this);
  }

  String get shortDayName {
    return DateFormat('E', 'fr_FR').format(this);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(this);
  }

  String get formattedTime {
    return DateFormat('HH:mm', 'fr_FR').format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DoubleExtensions on double {
  String toStringAsFixedWithUnit(int fractionDigits, String unit) {
    return '${toStringAsFixed(fractionDigits)}$unit';
  }

  String toTemperatureString({bool isCelsius = true}) {
    if (isCelsius) {
      return '${toStringAsFixed(1)}°C';
    } else {
      final fahrenheit = (this * 9 / 5) + 32;
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
  }

  String toSpeedString({bool isMetric = true}) {
    if (isMetric) {
      return '${toStringAsFixed(1)} km/h';
    } else {
      final mph = this * 0.621371;
      return '${mph.toStringAsFixed(1)} mph';
    }
  }
}

extension IntExtensions on int {
  String get asPercentage => '$this%';

  String toPressureString() {
    return '$this hPa';
  }

  String toVisibilityString() {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
    return '$this m';
  }
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  NavigatorState get navigator => Navigator.of(this);

  void showSnackBar(String message, {bool isError = false}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : theme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<T?> push<T>(String route, {Object? arguments}) {
    return navigator.pushNamed<T>(route, arguments: arguments);
  }

  void pop<T>([T? result]) {
    navigator.pop(result);
  }
}