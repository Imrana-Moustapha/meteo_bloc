import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meteo/core/constants/app_constants.dart';
import 'package:meteo/domain/repositories/weather_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final WeatherRepository repository;

  SettingsBloc({required this.repository}) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ClearCache>(_onClearCache);
    on<ResetSettings>(_onResetSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      final language = await repository.getLanguage();
      final darkMode = await repository.getDarkMode();

      emit(state.copyWith(
        status: SettingsStatus.loaded,
        languageCode: language ?? AppConstants.defaultLanguage,
        isDarkMode: darkMode ?? false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.saveLanguage(event.languageCode);
      emit(state.copyWith(languageCode: event.languageCode));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final newDarkMode = event.isDarkMode ?? !state.isDarkMode;
    
    try {
      await repository.saveDarkMode(newDarkMode);
      emit(state.copyWith(isDarkMode: newDarkMode));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      await repository.clearCache();
      emit(state.copyWith(
        status: SettingsStatus.loaded,
        cacheCleared: true,
        errorMessage: null,
      ));
      
      // Réinitialiser l'état de cache nettoyé après un délai
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(cacheCleared: false));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      // Réinitialiser la langue
      await repository.saveLanguage(AppConstants.defaultLanguage);
      
      // Réinitialiser le mode sombre
      await repository.saveDarkMode(false);
      
      // Nettoyer le cache
      await repository.clearCache();

      emit(const SettingsState(
        status: SettingsStatus.loaded,
        languageCode: AppConstants.defaultLanguage,
        isDarkMode: false,
        cacheCleared: true,
      ));
      
      // Réinitialiser l'état de cache nettoyé après un délai
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(cacheCleared: false));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateLanguage(String languageCode) {
    add(ChangeLanguage(languageCode));
  }

  void toggleDarkMode() {
    add(ToggleDarkMode());
  }

  void setDarkMode(bool isDarkMode) {
    add(ToggleDarkMode(isDarkMode: isDarkMode));
  }

  void clearAppCache() {
    add(ClearCache());
  }

  void resetAllSettings() {
    add(ResetSettings());
  }
}