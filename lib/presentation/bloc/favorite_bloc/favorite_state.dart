part of 'favorite_bloc.dart';

enum FavoriteStatus {
  initial,
  loading,
  loaded,
  error,
}

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<City> favorites;
  final List<City> recentCities;
  final String? errorMessage;
  final Set<String> favoriteIds;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.recentCities = const [],
    this.errorMessage,
    this.favoriteIds = const {},
  });

  bool get isEmpty => favorites.isEmpty;
  bool get hasError => errorMessage != null;
  bool isFavorite(String cityId) => favoriteIds.contains(cityId);

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<City>? favorites,
    List<City>? recentCities,
    String? errorMessage,
    Set<String>? favoriteIds,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      recentCities: recentCities ?? this.recentCities,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        favorites,
        recentCities,
        errorMessage,
        favoriteIds,
      ];
}