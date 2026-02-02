import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/l10n/app_localizations.dart';
import 'package:meteo/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/widgets/home/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const HomeContentScreen(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    // Initialisation des traductions
    final t = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        t.weatherTitle, // Utilise "Météo Niger" ou "Current Weather" selon la langue
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Colors.blue.shade800,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => Navigator.pushNamed(context, '/favorites'),
          tooltip: 'Favoris', // Tu peux ajouter une clé "favorites" dans tes .arb si besoin
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: t.settingsTitle, // Utilise "Paramètres" ou "Settings"
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _refreshWeather(context),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.refresh),
    );
  }

  void _refreshWeather(BuildContext context) {
    final weatherBloc = context.read<WeatherBloc>();

    if (!context.mounted) return;

    weatherBloc.add(RefreshWeatherEvent());

    // Pour le SnackBar, si tu as une clé de traduction pour le rafraîchissement, utilise-la ici
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Météo rafraîchie'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}