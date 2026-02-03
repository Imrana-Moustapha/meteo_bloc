import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meteo/l10n/app_localizations.dart';

class ExitConfirmationDialog extends StatefulWidget {
  const ExitConfirmationDialog({super.key});

  @override
  State<ExitConfirmationDialog> createState() => _ExitConfirmationDialogState();
}

class _ExitConfirmationDialogState extends State<ExitConfirmationDialog> {
  
  void _exitApp(BuildContext context) {
    // On ferme d'abord tous les écrans jusqu'au premier, puis on quitte l'application
    Navigator.of(context).popUntil((route) => route.isFirst);
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(t.exitTitle),
      content: Text(t.exitConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            // On ferme le dialogue avant de quitter
            Navigator.pop(context);
            _exitApp(context);
          },
          child: Text(t.exitTitle),
        ),
      ],
    );
  }
}