import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';
// Importation des traductions
import 'package:meteo/l10n/app_localizations.dart'; 

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

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
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
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
          subtitle: Text(subtitle),
          trailing: isSelected
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            context.read<ThemeCubit>().setThemeMode(mode);
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
      title: Text(t.themeLabel), // "Thème" traduit
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context,
            ThemeModeType.light,
            Icons.wb_sunny,
            t.themeLight,          // "Clair" traduit
            t.themeLightDesc,      // "Couleurs claires" traduit
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.dark,
            Icons.nightlight_round,
            t.themeDark,           // "Sombre" traduit
            t.themeDarkDesc,       // "Couleurs sombres" traduit
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.system,
            Icons.settings,
            t.themeSystem,         // "Système" traduit
            t.themeSystemDesc,     // "Suivre les paramètres du système" traduit
          ),
        ],
      ),
    );
  }
}