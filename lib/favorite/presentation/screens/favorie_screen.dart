import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/favorite/presentation/blocs/favorite_bloc/favorite_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoadingState) {
            return const Center(child: const Text('Chargement des favoris...'));
          }
          
          if (state is FavoriteErrorState) {
            return Center(child: Text('Erreur: ${state.message}'));
          }
          
          if (state is FavoriteLoadedState) {
            final favorites = state.favorites;
            
            if (favorites.isEmpty) {
              return const Center(child: Text('Aucun favori'));
            }
            
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return ListTile(
                  title: Text(favorite.cityName),
                  subtitle: Text(favorite.country),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoriteBloc>().add(RemoveFavoriteEvent(favorite.cityId));
                    },
                  ),
                  onTap: () {
                    // Naviguer vers la météo de cette ville
                  },
                );
              },
            );
          }
          
          return const Center(child: Text('Chargement...'));
        },
      ),
    );
  }
}