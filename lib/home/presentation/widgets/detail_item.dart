import 'package:flutter/material.dart';
import 'package:meteo/l10n/app_localizations.dart';

class DetailItem extends StatefulWidget {
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
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  @override
  Widget build(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    // Logique de traduction
    String translatedTitle = widget.title;
    
    if (widget.title.toLowerCase().contains('humidité')) {
      translatedTitle = t.humidity;
    } else if (widget.title.toLowerCase().contains('température')) {
      translatedTitle = t.temperature;
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
      children: [
        Icon(
          widget.icon, 
          color: Colors.blue, 
          size: 28
        ),
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
          widget.value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // Légèrement plus épais pour la lisibilité
          ),
        ),
      ],
    );
  }
}