// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get weatherNiger => 'Météo Niger';

  @override
  String get weatherTitle => 'Météo Actuelle';

  @override
  String get temperature => 'Température';

  @override
  String get description => 'Ciel dégagé';

  @override
  String get humidity => 'Humidité';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get themeLabel => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeLightDesc => 'Couleurs claires';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeDarkDesc => 'Couleurs sombres';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeSystemDesc => 'Suivre les paramètres du système';

  @override
  String get languageLabel => 'Langue';

  @override
  String get chooseLanguage => 'Choisir une langue';

  @override
  String get exitTitle => 'Quitter l\'application';

  @override
  String get exitSubtitle => 'Fermer l\'application';

  @override
  String get exitConfirmMessage =>
      'Êtes-vous sûr de vouloir quitter l\'application ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get searchHint => 'Rechercher une ville...';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get aboutTooltip => 'À propos';

  @override
  String get refreshTooltip => 'Rafraîchir';

  @override
  String get loadingMessage => 'Chargement de la météo...';

  @override
  String get returnDefaultTooltip => 'Retour à la ville par défaut';

  @override
  String get windSpeed => 'Vent';

  @override
  String get feelsLike => 'Ressenti';

  @override
  String get forecastTitle => 'Prévisions';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get view => 'Voir';

  @override
  String lastUpdate(String time) {
    return 'Dernière mise à jour : $time';
  }

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String addedToFavorites(String city) {
    return '$city ajouté aux favoris';
  }

  @override
  String alreadyInFavorites(String city) {
    return '$city est déjà dans vos favoris';
  }
}
