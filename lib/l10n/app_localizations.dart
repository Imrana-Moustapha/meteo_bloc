import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @weatherNiger.
  ///
  /// In fr, this message translates to:
  /// **'Météo Niger'**
  String get weatherNiger;

  /// Titre de la section météo principale
  ///
  /// In fr, this message translates to:
  /// **'Météo Actuelle'**
  String get weatherTitle;

  /// Label pour la température
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get temperature;

  /// Description de l'état du ciel
  ///
  /// In fr, this message translates to:
  /// **'Ciel dégagé'**
  String get description;

  /// Label pour le taux d'humidité
  ///
  /// In fr, this message translates to:
  /// **'Humidité'**
  String get humidity;

  /// Titre de la page des paramètres
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// Label pour le choix du thème
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get themeLabel;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeLightDesc.
  ///
  /// In fr, this message translates to:
  /// **'Couleurs claires'**
  String get themeLightDesc;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeDarkDesc.
  ///
  /// In fr, this message translates to:
  /// **'Couleurs sombres'**
  String get themeDarkDesc;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @themeSystemDesc.
  ///
  /// In fr, this message translates to:
  /// **'Suivre les paramètres du système'**
  String get themeSystemDesc;

  /// Label pour le choix de la langue
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageLabel;

  /// No description provided for @chooseLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une langue'**
  String get chooseLanguage;

  /// No description provided for @exitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter l\'application'**
  String get exitTitle;

  /// No description provided for @exitSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Fermer l\'application'**
  String get exitSubtitle;

  /// No description provided for @exitConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir quitter l\'application ?'**
  String get exitConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// Texte d'aide dans la barre de recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville...'**
  String get searchHint;

  /// Titre de la liste des favoris
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favoritesTitle;

  /// No description provided for @aboutTooltip.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTooltip;

  /// Bouton pour actualiser les données
  ///
  /// In fr, this message translates to:
  /// **'Rafraîchir'**
  String get refreshTooltip;

  /// No description provided for @loadingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Chargement de la météo...'**
  String get loadingMessage;

  /// No description provided for @returnDefaultTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la ville par défaut'**
  String get returnDefaultTooltip;

  /// Label pour la vitesse du vent
  ///
  /// In fr, this message translates to:
  /// **'Vent'**
  String get windSpeed;

  /// Label pour la température ressentie
  ///
  /// In fr, this message translates to:
  /// **'Ressenti'**
  String get feelsLike;

  /// Titre de la section prévisions
  ///
  /// In fr, this message translates to:
  /// **'Prévisions'**
  String get forecastTitle;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get tomorrow;

  /// Action pour voir les détails
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get view;

  /// Heure de la dernière synchronisation
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour : {time}'**
  String lastUpdate(String time);

  /// Bouton d'ajout en favoris
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get addToFavorites;

  /// Confirmation d'ajout
  ///
  /// In fr, this message translates to:
  /// **'{city} ajouté aux favoris'**
  String addedToFavorites(String city);

  /// Alerte si la ville existe déjà
  ///
  /// In fr, this message translates to:
  /// **'{city} est déjà dans vos favoris'**
  String alreadyInFavorites(String city);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
