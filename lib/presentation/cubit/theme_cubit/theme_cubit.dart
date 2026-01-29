import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeCubit() : super(ThemeState.initial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey) ?? 'system';
    
    ThemeModeType themeMode;
    bool isDarkMode;

    switch (savedTheme) {
      case 'dark':
        themeMode = ThemeModeType.dark;
        isDarkMode = true;
        break;
      case 'light':
        themeMode = ThemeModeType.light;
        isDarkMode = false;
        break;
      default:
        themeMode = ThemeModeType.system;
        isDarkMode = false;
    }

    emit(state.copyWith(
      themeMode: themeMode,
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> _saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  void toggleTheme() {
    if (state.themeMode == ThemeModeType.dark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }

  void setLightTheme() async {
    await _saveTheme('light');
    emit(state.copyWith(
      themeMode: ThemeModeType.light,
      isDarkMode: false,
    ));
  }

  void setDarkTheme() async {
    await _saveTheme('dark');
    emit(state.copyWith(
      themeMode: ThemeModeType.dark,
      isDarkMode: true,
    ));
  }

  void setSystemTheme() async {
    await _saveTheme('system');
    emit(state.copyWith(
      themeMode: ThemeModeType.system,
      isDarkMode: false,
    ));
  }

  void setThemeMode(ThemeModeType mode) {
    switch (mode) {
      case ThemeModeType.light:
        setLightTheme();
        break;
      case ThemeModeType.dark:
        setDarkTheme();
        break;
      case ThemeModeType.system:
        setSystemTheme();
        break;
    }
  }
}