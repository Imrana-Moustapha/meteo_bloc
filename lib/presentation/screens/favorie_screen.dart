import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/core/widgets/custom_widgets.dart';
import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/widgets/city_card.dart';
import 'package:meteo/presentation/widgets/loading_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state.hasError) {
            _showErrorSnackbar(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoriteState state) {
    if (state.status == FavoriteStatus.loading) {
      return const LoadingWidget(message: 'Chargement des favoris...');
    }

    if (state.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FavoriteBloc>().add(LoadFavorites());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final city = state.favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CityCard(
              city: city,
              onTap: () => _selectCity(context, city),
              onFavoriteToggle: () => _toggleFavorite(context, city),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucun favori',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Ajoutez des villes à vos favoris pour les retrouver ici',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: 'Rechercher des villes',
            icon: Icons.search,
            onPressed: () => _goToSearch(context),
            width: 200,
          ),
        ],
      ),
    );
  }

  void _selectCity(BuildContext context, City city) {
    context.read<WeatherBloc>().add(FetchWeather(city.name));
    Navigator.pop(context);
  }

  void _toggleFavorite(BuildContext context, City city) {
    context.read<FavoriteBloc>().add(ToggleFavorite(city));
  }

  void _goToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}