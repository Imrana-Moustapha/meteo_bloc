import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meteo/l10n/app_localizations.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  void _exitApp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
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
          ),
          onPressed: () {
            Navigator.pop(context);
            _exitApp(context);
          },
          child: Text(t.exitTitle),
        ),
      ],
    );
  }
}