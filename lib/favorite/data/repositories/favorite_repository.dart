import 'package:hive/hive.dart';
import 'package:meteo/favorite/data/model/favorite_model.dart';

class FavoriteRepository {
  final Box<FavoriteModel> _favoritesBox;
  
  FavoriteRepository() : _favoritesBox = Hive.box<FavoriteModel>('favorites');
  
  Future<List<FavoriteModel>> getAllFavorites() async {
    return _favoritesBox.values.toList();
  }
  
  Future<void> addFavorite(FavoriteModel favorite) async {
    await _favoritesBox.put(favorite.cityId, favorite);
  }
  
  Future<void> removeFavorite(String cityId) async {
    await _favoritesBox.delete(cityId);
  }
  
  Future<bool> isFavorite(String cityId) async {
    return _favoritesBox.containsKey(cityId);
  }
}