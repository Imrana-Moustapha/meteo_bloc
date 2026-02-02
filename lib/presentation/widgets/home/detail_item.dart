import 'package:flutter/material.dart';
import 'package:meteo/l10n/app_localizations.dart';

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    // Logique pour faire correspondre le titre statique aux clés des fichiers .arb
    String translatedTitle = title;
    
    if (title.toLowerCase().contains('humidité')) {
      translatedTitle = t.humidity;
    } else if (title.toLowerCase().contains('température')) {
      translatedTitle = t.temperature;
    }
    // Note : Si tu as d'autres titres comme "Vent" ou "Ressenti", 
    // assure-toi de les ajouter dans tes fichiers .arb (ex: t.wind, t.feelsLike)

    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 8),
        Text(
          translatedTitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}