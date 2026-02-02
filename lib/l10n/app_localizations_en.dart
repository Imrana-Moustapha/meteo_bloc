// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get weatherNiger => 'Niger Weather';

  @override
  String get weatherTitle => 'Current Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get description => 'Clear sky';

  @override
  String get humidity => 'Humidity';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeLightDesc => 'Light colors';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDarkDesc => 'Dark colors';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemDesc => 'Follow system settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get exitTitle => 'Exit Application';

  @override
  String get exitSubtitle => 'Close the app';

  @override
  String get exitConfirmMessage =>
      'Are you sure you want to exit the application?';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchHint => 'Search for a city...';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get aboutTooltip => 'About';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get loadingMessage => 'Loading weather...';

  @override
  String get returnDefaultTooltip => 'Return to default city';

  @override
  String get windSpeed => 'Wind';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get forecastTitle => 'Forecast';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get view => 'View';

  @override
  String lastUpdate(String time) {
    return 'Last update: $time';
  }

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String addedToFavorites(String city) {
    return '$city added to favorites';
  }

  @override
  String alreadyInFavorites(String city) {
    return '$city is already in favorites';
  }
}
