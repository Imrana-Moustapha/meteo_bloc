import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/core/widgets/custom_widgets.dart';
import 'package:meteo/presentation/bloc/setting_bloc/settings_bloc.dart';
import 'package:meteo/presentation/widgets/loading_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _showErrorSnackbar(context, state.errorMessage!);
          }
          
          if (state.cacheCleared) {
            _showSuccessSnackbar(context, 'Cache nettoyé avec succès');
          }
        },
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SettingsState state) {
    if (state.status == SettingsStatus.loading) {
      return const LoadingWidget(message: 'Chargement des paramètres...');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLanguageSection(context, state),
        const SizedBox(height: 20),
        _buildThemeSection(context, state),
        const SizedBox(height: 20),
        _buildCacheSection(context),
        const SizedBox(height: 20),
        _buildResetSection(context),
        const SizedBox(height: 40),
        _buildAppInfo(),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, SettingsState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langue',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            context,
            'Français',
            'fr',
            state.languageCode == 'fr',
            Icons.language,
          ),
          _buildLanguageOption(
            context,
            'English',
            'en',
            state.languageCode == 'en',
            Icons.language,
          ),
          _buildLanguageOption(
            context,
            'العربية',
            'ar',
            state.languageCode == 'ar',
            Icons.language,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String languageCode,
    bool isSelected,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () => _changeLanguage(context, languageCode),
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsState state) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thème',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              'Mode sombre',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Activer/désactiver le mode sombre',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: state.isDarkMode,
            onChanged: (value) => _toggleDarkMode(context, value),
            secondary: Icon(
              state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Données',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Nettoyer le cache',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Supprime toutes les données mises en cache',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onTap: () => _clearCache(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Réinitialisation',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              Icons.restart_alt,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Réinitialiser les paramètres',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Réinitialise tous les paramètres aux valeurs par défaut',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        Text(
          // CORRECTION : Utilisez une version par défaut
          'Météo v1.0.0', // Version par défaut
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '© 2024 Météo App',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    context.read<SettingsBloc>().add(ChangeLanguage(languageCode));
  }

  void _toggleDarkMode(BuildContext context, bool value) {
    context.read<SettingsBloc>().add(ToggleDarkMode(isDarkMode: value));
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nettoyer le cache'),
        content: const Text(
          'Voulez-vous vraiment supprimer toutes les données mises en cache ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsBloc>().add(ClearCache());
            },
            child: const Text(
              'Nettoyer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser'),
        content: const Text(
          'Voulez-vous vraiment réinitialiser tous les paramètres ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsBloc>().add(ResetSettings());
            },
            child: const Text(
              'Réinitialiser',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}