part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  final FavoriteModel favorite;
  
  const AddFavoriteEvent(this.favorite);
  
  @override
  List<Object> get props => [favorite];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String cityId;
  
  const RemoveFavoriteEvent(this.cityId);
  
  @override
  List<Object> get props => [cityId];
}