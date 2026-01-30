import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/loacal_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/loacal_state.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';
import 'package:meteo/presentation/widgets/settings/theme_dialog.dart';
import 'package:meteo/presentation/widgets/settings/language_dialog.dart';
import 'package:meteo/presentation/widgets/settings/exit_confirmation_dialog.dart';
import 'package:meteo/presentation/widgets/settings/settings_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getThemeName(ThemeModeType themeMode) {
    switch (themeMode) {
      case ThemeModeType.light:
        return 'Clair';
      case ThemeModeType.dark:
        return 'Sombre';
      case ThemeModeType.system:
        return 'Système';
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'Français';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ThemeDialog(),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ExitConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: state.isDarkMode
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                tooltip: 'Changer le thème',
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Thème
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SettingsCard(
                icon: state.themeMode == ThemeModeType.dark
                    ? Icons.nightlight_round
                    : state.themeMode == ThemeModeType.light
                        ? Icons.wb_sunny
                        : Icons.settings,
                title: 'Thème',
                subtitle: _getThemeName(state.themeMode),
                onTap: () => _showThemeDialog(context),
              );
            },
          ),

          const SizedBox(height: 16),

          // Section Langue
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return SettingsCard(
                icon: Icons.language,
                title: 'Langue',
                subtitle: _getLanguageName(state.languageCode),
                onTap: () => _showLanguageDialog(context),
              );
            },
          ),

          const SizedBox(height: 16),

          // Section Quitter l'application
          SettingsCard(
            icon: Icons.exit_to_app,
            title: 'Quitter l\'application',
            subtitle: 'Fermer l\'application',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () => _showExitConfirmationDialog(context),
          ),

          const SizedBox(height: 20),

          // Version
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}