import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/l10n/app_localizations.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_state.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';
import 'package:meteo/presentation/widgets/settings/theme_dialog.dart';
import 'package:meteo/presentation/widgets/settings/language_dialog.dart';
import 'package:meteo/presentation/widgets/settings/exit_confirmation_dialog.dart';
import 'package:meteo/presentation/widgets/settings/settings_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _getThemeName(BuildContext context, ThemeModeType themeMode) {
    final t = AppLocalizations.of(context)!;
    switch (themeMode) {
      case ThemeModeType.light: return t.themeLight;
      case ThemeModeType.dark: return t.themeDark;
      case ThemeModeType.system: return t.themeSystem;
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'fr': return 'Français';
      case 'en': return 'English';
      case 'ar': return 'العربية';
      default: return 'Français';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SettingsCard(
                icon: state.themeMode == ThemeModeType.dark ? Icons.nightlight_round : Icons.wb_sunny,
                title: t.themeLabel,
                subtitle: _getThemeName(context, state.themeMode),
                onTap: () => showDialog(context: context, builder: (_) => const ThemeDialog()),
              );
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return SettingsCard(
                icon: Icons.language,
                title: t.languageLabel,
                subtitle: _getLanguageName(state.languageCode),
                onTap: () => showDialog(context: context, builder: (_) => const LanguageDialog()),
              );
            },
          ),
          const SizedBox(height: 16),
          SettingsCard(
            icon: Icons.exit_to_app,
            title: t.exitTitle,
            subtitle: t.exitSubtitle,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () => showDialog(context: context, builder: (_) => const ExitConfirmationDialog()),
          ),
        ],
      ),
    );
  }
}