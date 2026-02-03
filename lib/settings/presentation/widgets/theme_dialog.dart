import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';
import 'package:meteo/l10n/app_localizations.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({super.key});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  
  // Widget interne pour construire les options de thème
  Widget _buildThemeOption(
    BuildContext context,
    ThemeModeType mode,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final bool isSelected = state.themeMode == mode;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          leading: Icon(
            icon,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            // Mise à jour du thème via le Cubit
            context.read<ThemeCubit>().setThemeMode(mode);
            // Fermeture automatique du dialogue
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        t.themeLabel,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context,
            ThemeModeType.light,
            Icons.wb_sunny,
            t.themeLight,
            t.themeLightDesc,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.dark,
            Icons.nightlight_round,
            t.themeDark,
            t.themeDarkDesc,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.system,
            Icons.settings_suggest, // Icone un peu plus moderne pour le système
            t.themeSystem,
            t.themeSystemDesc,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel), // Utilisation de ta clé de traduction "Annuler"
        ),
      ],
    );
  }
}