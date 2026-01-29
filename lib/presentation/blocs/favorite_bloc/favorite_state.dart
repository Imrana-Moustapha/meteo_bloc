part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitialState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  final List<FavoriteModel> favorites;
  
  const FavoriteLoadedState(this.favorites);
  
  @override
  List<Object> get props => [favorites];
}

class FavoriteErrorState extends FavoriteState {
  final String message;
  
  const FavoriteErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}