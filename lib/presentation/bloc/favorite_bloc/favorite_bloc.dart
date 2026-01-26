import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meteo/domain/entities/city.dart';
import 'package:meteo/domain/usecases/manage_favorites.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ManageFavorites manageFavorites;

  FavoriteBloc({required this.manageFavorites})
      : super(const FavoriteState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavorite>(_onCheckFavorite);
    on<LoadRecentCities>(_onLoadRecentCities);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(status: FavoriteStatus.loading));

    final result = await manageFavorites.getFavorites();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: FavoriteStatus.error,
          errorMessage: failure.message,
        ));
      },
      (favorites) {
        final favoriteIds = Set<String>.from(
          favorites.map((city) => city.id),
        );

        emit(state.copyWith(
          status: FavoriteStatus.loaded,
          favorites: favorites,
          favoriteIds: favoriteIds,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await manageFavorites.addFavorite(event.city);

    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        final updatedFavorites = List<City>.from(state.favorites)
          ..add(event.city);
        final updatedFavoriteIds = Set<String>.from(state.favoriteIds)
          ..add(event.city.id);

        emit(state.copyWith(
          favorites: updatedFavorites,
          favoriteIds: updatedFavoriteIds,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await manageFavorites.removeFavorite(event.cityId);

    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        final updatedFavorites = state.favorites
            .where((city) => city.id != event.cityId)
            .toList();
        final updatedFavoriteIds = Set<String>.from(state.favoriteIds)
          ..remove(event.cityId);

        emit(state.copyWith(
          favorites: updatedFavorites,
          favoriteIds: updatedFavoriteIds,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state.isFavorite(event.city.id)) {
      add(RemoveFavorite(event.city.id));
    } else {
      add(AddFavorite(event.city));
    }
  }

  Future<void> _onCheckFavorite(
    CheckFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await manageFavorites.isFavorite(event.cityId);

    result.fold(
      (failure) {
        // Ne pas émettre d'erreur pour une simple vérification
      },
      (isFavorite) {
        final updatedFavoriteIds = Set<String>.from(state.favoriteIds);
        if (isFavorite) {
          updatedFavoriteIds.add(event.cityId);
        } else {
          updatedFavoriteIds.remove(event.cityId);
        }

        emit(state.copyWith(favoriteIds: updatedFavoriteIds));
      },
    );
  }

  Future<void> _onLoadRecentCities(
    LoadRecentCities event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await manageFavorites.getRecentCities();

    result.fold(
      (failure) {
        // Ne pas émettre d'erreur, on garde les récentes existantes
      },
      (recentCities) {
        emit(state.copyWith(recentCities: recentCities));
      },
    );
  }

  void addFavoriteCity(City city) {
    add(AddFavorite(city));
  }

  void removeFavoriteCity(String cityId) {
    add(RemoveFavorite(cityId));
  }

  void toggleFavoriteCity(City city) {
    add(ToggleFavorite(city));
  }

  void checkFavoriteStatus(String cityId) {
    add(CheckFavorite(cityId));
  }

  void reloadFavorites() {
    add(LoadFavorites());
  }
}