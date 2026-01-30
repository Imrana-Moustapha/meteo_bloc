# Météo - Application Météo Flutter

Une application météo élégante et performante développée avec Flutter, utilisant l'architecture BLoC pour la gestion d'état, Hive pour le stockage local et l'API OpenWeather pour les données météorologiques.

## Fonctionnalités

### Principales
- **Affichage météo actuelle** : Température, conditions, humidité, vitesse du vent
- **Prévisions sur jours** : Vue détaillée des prévisions horaires et quotidiennes
- **Recherche par ville** : Support multilingue pour les noms de villes
- **Favoris** : Sauvegarde des villes favorites pour un accès rapide

## Architecture

### Structure du Projet
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

###  Flux de données
```
UI → Bloc/Cubit → UseCase → Repository → DataSource (API/Hive)
```

## Technologies Utilisées

### 📦 Dépendances principales
```yaml
dependencies:
  # Gestion d'état
  flutter_bloc: ^8.1.3
  
  # Stockage local
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # HTTP & API
  dio: ^5.3.3
  retrofit: ^4.0.1
  
  # Gestion des données
  equatable: ^2.0.5
  
  # Utilitaires
  intl: ^0.18.1
  
  # Géolocalisation
  geolocator: ^10.1.0
```

### Dépendances de développement
```yaml
dev_dependencies:
  # Génération de code
  build_runner: ^2.4.6
  hive_generator: ^1.1.3
  
  # Tests
  bloc_test: ^9.1.4
  flutter_test: 
  
```

##  Configuration

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
cd meteo_bloc

# 2. Installez les dépendances
flutter pub get

# 3. Générez les fichiers de code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Lancez l'application
flutter run
```

## Pages de l'Application

### 1. Page Principale
- Météo actuelle de la position géographique
- Prévisions sur 24h

### 2. Recherche
- Barre de recherche intelligente

### 3. Favoris
- Liste des villes favorites
- Mise à jour automatique

### 4.  Paramètres
- Thème sombre/clair
- Langue de l'application

## Gestion d'État avec BLoC

### Blocs principaux
```dart
WeatherBloc          # Gestion des données météo
<!-- LocationBloc    # Gestion de la géolocalisation -->
FavoritesBloc        # Gestion des favoris
SettingsBloc         # Gestion des paramètres
<!-- ThemeBloc       # Gestion du thème -->
```

### Processus
1. Fork du projet
2. Création d'une branche (`feature/ma-feature`)
3. Commit des modifications
4. Push vers la branche
5. Ouverture d'une Pull Request

### Contact
Pour les bugs et suggestions, ouvrez une issue sur GitHub.

---
*Dernière mise à jour : ${new Date().toLocaleDateString()}*
