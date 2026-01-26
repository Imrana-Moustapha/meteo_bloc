part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final City city;

  const AddFavorite(this.city);

  @override
  List<Object> get props => [city];
}

class RemoveFavorite extends FavoriteEvent {
  final String cityId;

  const RemoveFavorite(this.cityId);

  @override
  List<Object> get props => [cityId];
}

class ToggleFavorite extends FavoriteEvent {
  final City city;

  const ToggleFavorite(this.city);

  @override
  List<Object> get props => [city];
}

class CheckFavorite extends FavoriteEvent {
  final String cityId;

  const CheckFavorite(this.cityId);

  @override
  List<Object> get props => [cityId];
}

class LoadRecentCities extends FavoriteEvent {}