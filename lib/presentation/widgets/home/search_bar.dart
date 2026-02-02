import 'package:flutter/material.dart';
import 'package:meteo/l10n/app_localizations.dart'; // Import pour les traductions

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String currentCity;
  final Function(String) onSearch;
  final VoidCallback onReturnToDefault;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.currentCity,
    required this.onSearch,
    required this.onReturnToDefault,
  });

  @override
  Widget build(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  // Utilisation d'une clé de traduction pour le texte d'aide
                  // Si tu n'as pas encore cette clé, tu peux utiliser t.weatherTitle 
                  // ou en créer une nouvelle comme t.searchHint
                  hintText: t.searchHint, 
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: Colors.blue),
                ),
                onSubmitted: onSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.blue),
              onPressed: onReturnToDefault,
              // Traduction du tooltip
              // Note : Pour inclure dynamiquement le nom de la ville, 
              // il est préférable d'avoir une clé paramétrée dans ton .arb
              tooltip: '${t.returnDefaultTooltip} ($currentCity)',
            ),
          ],
        ),
      ),
    );
  }
}