import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_state.dart';


class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

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
          leading: const Icon(Icons.language),
          title: Text(displayName),
          trailing: isSelected
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            context.read<LocaleCubit>().changeLanguage(languageCode);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir une langue'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(context, 'fr', 'Français'),
          const Divider(height: 1),
          _buildLanguageOption(context, 'en', 'English'),
          const Divider(height: 1),
          _buildLanguageOption(context, 'ar', 'العربية'),
        ],
      ),
    );
  }
}