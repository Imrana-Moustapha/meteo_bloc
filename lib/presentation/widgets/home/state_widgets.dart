import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/data/models/favorite_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/widgets/home/weather_content.dart';

class StateWidgets {
  static Widget build({
    required BuildContext context,
    required WeatherState state,
    required String currentCity,
    required VoidCallback onRefresh,
    required VoidCallback onReturnToDefault,
  }) {
    if (state is WeatherLoadingState) {
      return _buildLoadingWidget();
    }
    
    if (state is WeatherRefreshingState) {
      return _buildRefreshingWidget(context, state);
    }
    
    if (state is WeatherErrorState) {
      return _buildErrorWidget(state.message, onRefresh, onReturnToDefault);
    }
    
    if (state is WeatherLoadedState) {
      return _buildWeatherWidget(context, state, onRefresh);
    }
    
    return _buildWelcomeWidget();
  }

  static Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Chargement de la météo pour Niamey...'),
        ],
      ),
    );
  }

  static Widget _buildRefreshingWidget(BuildContext context, WeatherRefreshingState state) {
    void addToFavorites() {
      _addFavoriteToBloc(context, state.weather);
    }

    return WeatherContent(
      weather: state.weather,
      forecasts: state.forecasts,
      isRefreshing: true,
      onRefresh: () {},
      onAddToFavorites: addToFavorites,
    );
  }

  static Widget _buildErrorWidget(String message, VoidCallback onRefresh, VoidCallback onReturnToDefault) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            onPressed: onRefresh,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Retour à Niamey'),
            onPressed: onReturnToDefault,
          ),
        ],
      ),
    );
  }

  static Widget _buildWeatherWidget(BuildContext context, WeatherLoadedState state, VoidCallback onRefresh) {
    void addToFavorites() {
      _addFavoriteToBloc(context, state.weather);
    }

    return WeatherContent(
      weather: state.weather,
      forecasts: state.forecasts,
      onRefresh: onRefresh,
      onAddToFavorites: addToFavorites,
    );
  }

  static Widget _buildWelcomeWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sunny,
            size: 120,
            color: Colors.orange.shade300,
          ),
          const SizedBox(height: 30),
          Text(
            'Météo Niger',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Bienvenue ! L\'application affiche la météo de Niamey par défaut. Recherchez une autre ville si nécessaire.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Rechercher une autre ville'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  static void _addFavoriteToBloc(BuildContext context, WeatherModel weather) {
    try {
      final favoriteBloc = context.read<FavoriteBloc>();
      
      final currentState = favoriteBloc.state;
      
      final cityId = _generateCityId(weather.cityName);
      
      if (currentState is FavoriteLoadedState) {
        final isAlreadyFavorite = currentState.favorites
            .any((fav) => fav.cityName.toLowerCase() == weather.cityName.toLowerCase());
        
        if (isAlreadyFavorite) {
          _showSnackBar(
            context,
            '${weather.cityName} est déjà dans vos favoris',
            isError: false,
          );
          return;
        }
      }
      
      final favorite = FavoriteModel(
        cityId: cityId,
        cityName: weather.cityName,
        country: 'Niger', 
        lat: 13.5127,
        lon: 2.1121,
        addedAt: DateTime.now(),
      );
      
      favoriteBloc.add(AddFavoriteEvent(favorite));
      
      _showSnackBar(
        context,
        '${weather.cityName} a été ajouté aux favoris',
        isError: false,
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () {
            Navigator.pushNamed(context, '/favorites');
          },
        ),
      );
      
    } catch (e) {
      _showSnackBar(
        context,
        'Erreur lors de l\'ajout aux favoris: ${e.toString()}',
        isError: true,
      );
    }
  }

  static String _generateCityId(String cityName) {
    final now = DateTime.now();
    return '${cityName.toLowerCase().replaceAll(' ', '_')}_${now.millisecondsSinceEpoch}';
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : null,
        action: action,
      ),
    );
  }
}