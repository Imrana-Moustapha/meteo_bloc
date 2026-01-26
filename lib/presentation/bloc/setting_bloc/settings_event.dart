part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class ToggleDarkMode extends SettingsEvent {
  final bool? isDarkMode;

  const ToggleDarkMode({this.isDarkMode});

  @override
  List<Object> get props => [];
}

class ClearCache extends SettingsEvent {}

class ResetSettings extends SettingsEvent {}