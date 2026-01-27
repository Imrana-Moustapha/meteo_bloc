import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meteo/data/models/favorite_model.dart';
import 'package:meteo/data/models/weather_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  String _temperatureUnit = 'celsius';
  String _language = 'fr';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsBox = Hive.box('settings');
    
    setState(() {
      _notifications = settingsBox.get('notifications', defaultValue: false);
      _temperatureUnit = settingsBox.get('temperatureUnit', defaultValue: 'celsius');
      _language = settingsBox.get('language', defaultValue: 'fr');
    });
  }

  Future<void> _saveSettings() async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('notifications', _notifications);
    await settingsBox.put('temperatureUnit', _temperatureUnit);
    await settingsBox.put('language', _language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
                _saveSettings();
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Unité de température'),
            subtitle: Text(_temperatureUnit == 'celsius' ? 'Celsius' : 'Fahrenheit'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Choisir une unité'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Celsius'),
                          onTap: () {
                            setState(() {
                              _temperatureUnit = 'celsius';
                              _saveSettings();
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Fahrenheit'),
                          onTap: () {
                            setState(() {
                              _temperatureUnit = 'fahrenheit';
                              _saveSettings();
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Langue'),
            subtitle: Text(_language == 'fr' ? 'Français' : 'Anglais'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Choisir une langue'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Français'),
                          onTap: () {
                            setState(() {
                              _language = 'fr';
                              _saveSettings();
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Anglais'),
                          onTap: () {
                            setState(() {
                              _language = 'en';
                              _saveSettings();
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Effacer le cache'),
              onPressed: () {
                Hive.box<FavoriteModel>('favorites').clear();
                Hive.box<WeatherModel>('weather_cache').clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache effacé')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}