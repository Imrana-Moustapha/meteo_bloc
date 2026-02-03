import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_state.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  
  // Widget interne pour construire les options
  Widget _buildLanguageOption(
    BuildContext context,
    String languageCode,
    String displayName,
  ) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final bool isSelected = state.languageCode == languageCode;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(
            Icons.language, 
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey
          ),
          title: Text(
            displayName,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            // Changement de langue via le Cubit
            context.read<LocaleCubit>().changeLanguage(languageCode);
            // Fermeture du dialogue
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Choisir une langue',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          _buildLanguageOption(context, 'fr', 'Français'),
          const Divider(height: 1),
          _buildLanguageOption(context, 'en', 'English'),
          const Divider(height: 1),
          _buildLanguageOption(context, 'ar', 'العربية'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}