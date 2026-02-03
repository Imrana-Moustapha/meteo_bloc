import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/favorite/data/model/favorite_model.dart';
import 'package:meteo/weather/data/models/weather_model.dart';
import 'package:meteo/l10n/app_localizations.dart';
import 'package:meteo/weather/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/favorite/presentation/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/home/presentation/widgets/weather_content.dart';

class StateWidgets {
  static Widget build({
    required BuildContext context,
    required WeatherState state,
    required String currentCity,
    required VoidCallback onRefresh,
    required VoidCallback onReturnToDefault,
  }) {
    if (state is WeatherLoadingState) {
      return _buildLoadingWidget(context);
    }
    
    if (state is WeatherRefreshingState) {
      return _buildRefreshingWidget(context, state);
    }
    
    if (state is WeatherErrorState) {
      return _buildErrorWidget(context, state.message, onRefresh, onReturnToDefault);
    }
    
    if (state is WeatherLoadedState) {
      return _buildWeatherWidget(context, state, onRefresh);
    }
    
    return _buildWelcomeWidget(context);
  }

  static Widget _buildLoadingWidget(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(t?.loadingMessage ?? 'Chargement...'),
        ],
      ),
    );
  }

  static Widget _buildRefreshingWidget(BuildContext context, WeatherRefreshingState state) {
    return WeatherContent(
      weather: state.weather,
      forecasts: state.forecasts,
      isRefreshing: true,
      onRefresh: () {},
      onAddToFavorites: () => _addFavoriteToBloc(context, state.weather),
    );
  }

  static Widget _buildErrorWidget(BuildContext context, String message, VoidCallback onRefresh, VoidCallback onReturnToDefault) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            t?.weatherTitle ?? 'Erreur',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: Text(t?.refreshTooltip ?? 'Réessayer'),
            onPressed: onRefresh,
          ),
          TextButton(
            onPressed: onReturnToDefault,
            child: Text(t?.returnDefaultTooltip ?? 'Retour'),
          ),
        ],
      ),
    );
  }

  static Widget _buildWeatherWidget(BuildContext context, WeatherLoadedState state, VoidCallback onRefresh) {
    return WeatherContent(
      weather: state.weather,
      forecasts: state.forecasts,
      onRefresh: onRefresh,
      onAddToFavorites: () => _addFavoriteToBloc(context, state.weather),
    );
  }

  static Widget _buildWelcomeWidget(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sunny, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          Text(t?.weatherNiger ?? 'Météo Niger', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(t?.searchHint ?? 'Recherchez une ville', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  static void _addFavoriteToBloc(BuildContext context, WeatherModel weather) {
    final t = AppLocalizations.of(context);
    final favoriteBloc = context.read<FavoriteBloc>();
    final currentState = favoriteBloc.state;

    if (currentState is FavoriteLoadedState) {
      final isAlreadyFavorite = currentState.favorites.any((fav) => fav.cityName.toLowerCase() == weather.cityName.toLowerCase());
      if (isAlreadyFavorite) {
        _showSnackBar(context, t?.alreadyInFavorites(weather.cityName) ?? 'Déjà en favoris');
        return;
      }
    }

    final favorite = FavoriteModel(
      cityId: '${weather.cityName.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      cityName: weather.cityName,
      country: 'Niger',
      lat: 13.5127,
      lon: 2.1121,
      addedAt: DateTime.now(),
    );

    favoriteBloc.add(AddFavoriteEvent(favorite));
    _showSnackBar(
      context,
      t?.addedToFavorites(weather.cityName) ?? 'Ajouté',
      action: SnackBarAction(label: t?.view ?? 'Voir', onPressed: () => Navigator.pushNamed(context, '/favorites')),
    );
  }

  static void _showSnackBar(BuildContext context, String message, {bool isError = false, SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : null,
      action: action,
    ));
  }
}