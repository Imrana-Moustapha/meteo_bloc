part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  loading,
  loaded,
  error,
}

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String languageCode;
  final bool isDarkMode;
  final String? errorMessage;
  final bool cacheCleared;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.languageCode = 'fr',
    this.isDarkMode = false,
    this.errorMessage,
    this.cacheCleared = false,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? languageCode,
    bool? isDarkMode,
    String? errorMessage,
    bool? cacheCleared,
  }) {
    return SettingsState(
      status: status ?? this.status,
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      errorMessage: errorMessage ?? this.errorMessage,
      cacheCleared: cacheCleared ?? this.cacheCleared,
    );
  }

  @override
  List<Object?> get props => [
        status,
        languageCode,
        isDarkMode,
        errorMessage,
        cacheCleared,
      ];
}