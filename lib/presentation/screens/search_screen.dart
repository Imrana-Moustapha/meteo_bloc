import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/core/widgets/custom_widgets.dart';
import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/domain/usecases/manage_favorites.dart';
import 'package:meteo/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/widgets/city_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ManageFavorites manageFavorites;
  Timer? _debounceTimer;
  List<City> _searchResults = [];

  @override
  void initState() {
    super.initState();
    manageFavorites = context.read<ManageFavorites>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomTextField(
        controller: _searchController,
        hintText: 'Rechercher une ville...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults = [];
                  });
                },
              )
            : null,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearchSubmitted,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return _buildRecentCities();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptySearch();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final city = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CityCard(
            city: city,
            onTap: () => _selectCity(context, city),
            onFavoriteToggle: () => _toggleFavorite(city),
          ),
        );
      },
    );
  }

  Widget _buildRecentCities() {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state.recentCities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 20),
                Text(
                  'Recherchez une ville',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Commencez à taper pour rechercher une ville',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Villes récentes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.recentCities.length,
                itemBuilder: (context, index) {
                  final city = state.recentCities[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CityCard(
                      city: city,
                      onTap: () => _selectCity(context, city),
                      onFavoriteToggle: () => _toggleFavorite(city),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucun résultat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Aucune ville trouvée pour "${_searchController.text}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 2) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.length >= 2) {
      _performSearch(query);
    }
  }

  Future<void> _performSearch(String query) async {
    final result = await manageFavorites.searchCities(query);
    
    result.fold(
      (failure) {
        _showErrorSnackbar(context, failure.message);
      },
      (cities) {
        setState(() {
          _searchResults = cities;
        });
      },
    );
  }

  void _selectCity(BuildContext context, City city) {
    context.read<WeatherBloc>().add(FetchWeather(city.name));
    Navigator.pop(context, city.name);
  }

  void _toggleFavorite(City city) {
    context.read<FavoriteBloc>().add(ToggleFavorite(city));
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