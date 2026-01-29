import 'package:equatable/equatable.dart';

enum ThemeModeType { light, dark, system }

class ThemeState extends Equatable {
  final ThemeModeType themeMode;
  final bool isDarkMode;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeModeType.system,
      isDarkMode: false,
    );
  }

  ThemeState copyWith({
    ThemeModeType? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [themeMode, isDarkMode];
}