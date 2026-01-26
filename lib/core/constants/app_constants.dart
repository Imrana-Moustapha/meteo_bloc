class AppConstants {
  // Langues supportées
  static const List<String> supportedLanguages = ['en', 'fr', 'ar'];
  static const String defaultLanguage = 'fr';
  
  // Clés de stockage
  static const String localeKey = 'app_locale';
  static const String themeKey = 'app_theme';
  static const String firstLaunchKey = 'first_launch';
  
  // Temps
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(minutes: 10);
  
  // Chemins Hive
  static const String weatherBox = 'weather_box';
  static const String favoritesBox = 'favorites_box';
  static const String settingsBox = 'settings_box';
  
  // Routes
  static const String homeRoute = '/';
  static const String favoritesRoute = '/favorites';
  static const String settingsRoute = '/settings';
  static const String searchRoute = '/search';
  static const String detailRoute = '/detail';
}

class AppAssets {
  static const String appLogo = 'assets/logo.png';
  static const String placeholder = 'assets/placeholder.png';
}

class AppStrings {
  // Titres
  static const String appName = 'Météo';
  static const String homeTitle = 'Accueil';
  static const String favoritesTitle = 'Favoris';
  static const String settingsTitle = 'Paramètres';
  static const String searchTitle = 'Rechercher';
  static const String detailTitle = 'Détails';
  
  // Messages
  static const String loading = 'Chargement...';
  static const String error = 'Erreur';
  static const String retry = 'Réessayer';
  static const String noData = 'Aucune donnée disponible';
  static const String noFavorites = 'Aucun favori';
  static const String noInternet = 'Pas de connexion internet';
  
  // Actions
  static const String addFavorite = 'Ajouter aux favoris';
  static const String removeFavorite = 'Retirer des favoris';
  static const String refresh = 'Actualiser';
  static const String search = 'Rechercher une ville...';
  static const String cancel = 'Annuler';
  static const String save = 'Sauvegarder';
  static const String reset = 'Réinitialiser';
}

class TemperatureUnits {
  static const String celsius = '°C';
  static const String fahrenheit = '°F';
  static const String kelvin = 'K';
}

class SpeedUnits {
  static const String kmh = 'km/h';
  static const String mph = 'mph';
  static const String ms = 'm/s';
}