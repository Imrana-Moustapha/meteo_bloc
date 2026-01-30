import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';

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
    return AlertDialog(
      title: const Text('Thème'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context,
            ThemeModeType.light,
            Icons.wb_sunny,
            'Clair',
            'Couleurs claires',
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.dark,
            Icons.nightlight_round,
            'Sombre',
            'Couleurs sombres',
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ThemeModeType.system,
            Icons.settings,
            'Système',
            'Suivre les paramètres du système',
          ),
        ],
      ),
    );
  }
}