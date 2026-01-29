import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meteo/data/models/favorite_model.dart';
import 'package:meteo/data/repositories/favorite_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  
  FavoriteBloc(this.favoriteRepository) : super(FavoriteInitialState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }
  
  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoadingState());
    
    try {
      final favorites = await favoriteRepository.getAllFavorites();
      emit(FavoriteLoadedState(favorites));
    } catch (e) {
      emit(FavoriteErrorState(e.toString()));
    }
  }
  
  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await favoriteRepository.addFavorite(event.favorite);
      final favorites = await favoriteRepository.getAllFavorites();
      emit(FavoriteLoadedState(favorites));
    } catch (e) {
      emit(FavoriteErrorState(e.toString()));
    }
  }
  
  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await favoriteRepository.removeFavorite(event.cityId);
      final favorites = await favoriteRepository.getAllFavorites();
      emit(FavoriteLoadedState(favorites));
    } catch (e) {
      emit(FavoriteErrorState(e.toString()));
    }
  }
}