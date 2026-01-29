# 🌤️ Météo - Application Météo Flutter

Une application météo élégante et performante développée avec Flutter, utilisant l'architecture BLoC pour la gestion d'état, Hive pour le stockage local et l'API OpenWeather pour les données météorologiques.

## ✨ Fonctionnalités

### 🎯 Principales
- **Affichage météo actuelle** : Température, conditions, humidité, vitesse du vent
- **Prévisions sur 5 jours** : Vue détaillée des prévisions horaires et quotidiennes
- **Recherche par ville** : Support multilingue pour les noms de villes
- **Favoris** : Sauvegarde des villes favorites pour un accès rapide

## 🏗️ Architecture

### 📁 Structure du Projet
```
lib/
├── core/
│   ├── constants/      # Constantes et configurations
│   ├── services/       # Thèmes de l'application
│   
├── data/
│   ├── models/         # Modèles de données
│   └── repositories/   # Répositories
└── presentation/
    ├── blocs/          # Blocs pour la gestion d'état
    ├── home/           # Pages de l'application
    └── widgets/        # Widgets spécifiques aux pages
```

### 🔄 Flux de données
```
UI → Bloc/Cubit → UseCase → Repository → DataSource (API/Hive)
```

## 🚀 Technologies Utilisées

### 📦 Dépendances principales
```yaml
dependencies:
  # Gestion d'état
  flutter_bloc: ^8.1.3
  hydrated_bloc: ^9.1.2
  
  # Stockage local
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # HTTP & API
  dio: ^5.3.3
  retrofit: ^4.0.1
  
  # Gestion des données
  equatable: ^2.0.5
  freezed: ^2.4.5
  
  # Utilitaires
  get_it: ^7.6.4
  injectable: ^2.1.2
  intl: ^0.18.1
  
  # UI
  flutter_svg: ^2.0.9
  lottie: ^2.7.0
  shimmer: ^3.0.0
  
  # Géolocalisation
  geolocator: ^10.1.0
  permission_handler: ^10.4.4
```

### 🔧 Dépendances de développement
```yaml
dev_dependencies:
  # Génération de code
  build_runner: ^2.4.6
  hive_generator: ^1.1.3
  retrofit_generator: ^4.0.1
  freezed_annotation: ^2.4.1
  injectable_generator: ^2.1.2
  
  # Tests
  bloc_test: ^9.1.4
  mockito: ^5.4.2
  flutter_test: 
  
  # Qualité de code
  flutter_lints: ^3.0.1
```

## ⚙️ Configuration

### 1. Clé API OpenWeather
1. Créez un compte sur [OpenWeather](https://openweathermap.org/api)
2. Générez une clé API
3. Ajoutez-la au fichier `.env` :
```env
OPENWEATHER_API_KEY=votre_clé_api_ici
```

### 2. Configuration Hive
Initialisez Hive dans `main.dart` :
```
await Hive.init();
```

### 3. Variables d'environnement
Créez un fichier `.env` à la racine :
```env
OPENWEATHER_BASE_URL=https://api.openweathermap.org/data/2.5
OPENWEATHER_API_KEY=votre_clé_api
WEATHER_ICON_URL=https://openweathermap.org/img/wn
```

## 🏃‍♂️ Installation

### Prérequis
- Flutter SDK >= 3.0.0
- Dart >= 2.19.0

### Étapes d'installation
```bash
# 1. Clonez le dépôt
git clone <https://github.com/Imrana-Moustapha/meteo_bloc>
cd weatherapp

# 2. Installez les dépendances
flutter pub get

# 3. Générez les fichiers de code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Lancez l'application
flutter run
```

## 📱 Pages de l'Application

### 1. 🌤️ Page Principale
- Météo actuelle de la position géographique
- Prévisions sur 24h
- Indicateurs détaillés (UV, pression, visibilité)

### 2. 🔍 Recherche
- Barre de recherche intelligente
- Suggestions automatiques
- Historique des recherches

### 3. ⭐ Favoris
- Liste des villes favorites
- Glisser pour supprimer
- Mise à jour automatique

### 4. ⚙️ Paramètres
- Changement d'unités (°C/°F, km/h/mph)
- Thème sombre/clair
- Langue de l'application
- Gestion du cache

## 🔧 Gestion d'État avec BLoC

### Blocs principaux
```dart
WeatherBloc          # Gestion des données météo
<!-- LocationBloc         # Gestion de la géolocalisation -->
FavoritesBloc        # Gestion des favoris
SettingsBloc         # Gestion des paramètres
<!-- ThemeBloc            # Gestion du thème -->
```

### Exemple d'utilisation
```dart
BlocBuilder<WeatherBloc, WeatherState>(
  builder: (context, state) {
    if (state is WeatherLoading) {
      return LoadingWidget();
    } else if (state is WeatherLoaded) {
      return WeatherCard(weather: state.weather);
    } else if (state is WeatherError) {
      return ErrorWidget(message: state.message);
    }
    return Container();
  },
)
```

## 💾 Stockage avec Hive

### Modèles Hive
```dart
@HiveType(typeId: 0)
class WeatherCache extends HiveObject {
  @HiveField(0)
  final String city;
  
  @HiveField(1)
  final WeatherData data;
  
  @HiveField(2)
  final DateTime timestamp;
}
```

### Gestion du cache
- Cache automatique des données
- Expiration après 30 minutes
- Synchronisation intelligente

## 🌐 Intégration API OpenWeather

### Endpoints utilisés
```dart
// Météo actuelle
GET /weather?q={city}&appid={apiKey}

// Prévisions sur 5 jours
GET /forecast?q={city}&appid={apiKey}

// Par coordonnées
GET /weather?lat={lat}&lon={lon}&appid={apiKey}
```

### Gestion des erreurs
- Reconnexion automatique
- Fallback sur données cache
- Messages d'erreur localisés

## 🧪 Tests

### Exécution des tests
```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter drive --target=test_driver/app.dart

# Tests de performance
flutter run --profile test_driver/app.dart
```

### Couverture de test
- Tests unitaires pour les blocs
- Tests d'intégration pour les repositories
- Tests widget pour l'interface

## 🚀 Build & Déploiement

### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📊 Performance

### Optimisations
- **Lazy loading** des images
- **Cache mémoire** des données fréquentes
- **Debouncing** des recherches
- **Compression** des requêtes réseau
- **Pagination** des données historiques

### Monitoring
- Analytics Firebase
- Crashlytics
- Performance Monitoring

## 🤝 Contribution

### Style de code
- Respect des conventions Flutter
- Documentation des méthodes publiques
- Tests pour les nouvelles fonctionnalités

### Processus
1. Fork du projet
2. Création d'une branche (`feature/ma-feature`)
3. Commit des modifications
4. Push vers la branche
5. Ouverture d'une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

### Problèmes connus
- [ ] Support iPad/Tablette
- [ ] Widgets homescreen
- [ ] Notifications météo

### Contact
Pour les bugs et suggestions, ouvrez une issue sur GitHub.

---

**Développé avec ❤️ en utilisant Flutter**  
*Dernière mise à jour : ${new Date().toLocaleDateString()}*