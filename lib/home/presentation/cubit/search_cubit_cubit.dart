import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/home/presentation/cubit/search_cubit_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchHistoryLoaded([]));

  static const String _key = 'search_history';

  // Charger l'historique au démarrage
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    emit(SearchHistoryLoaded(history));
  }

  // Ajouter une ville
  Future<void> addToHistory(String city) async {
    if (city.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final currentHistory = List<String>.from(state.history);
    
    currentHistory.remove(city); // Éviter les doublons
    currentHistory.insert(0, city);
    
    if (currentHistory.length > 5) currentHistory.removeLast();
    
    await prefs.setStringList(_key, currentHistory);
    emit(SearchHistoryLoaded(currentHistory));
  }

  // Supprimer une ville
  Future<void> removeFromHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHistory = List<String>.from(state.history);
    
    currentHistory.remove(city);
    
    await prefs.setStringList(_key, currentHistory);
    emit(SearchHistoryLoaded(currentHistory));
  }
}