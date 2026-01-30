import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  void _exitApp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quitter l\'application'),
      content: const Text(
        'Êtes-vous sûr de vouloir quitter l\'application ?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            _exitApp(context);
          },
          child: const Text('Quitter'),
        ),
      ],
    );
  }
}