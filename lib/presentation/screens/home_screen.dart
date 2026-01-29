import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/screens/favorie_screen.dart';
import 'package:meteo/presentation/screens/setting_screen.dart';
import 'package:meteo/presentation/widgets/home/bottom_nav_bar.dart';
import 'package:meteo/presentation/widgets/home/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContentScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _pages[_selectedIndex],
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Météo Niger',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.blue.shade800,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshWeather(context),
          tooltip: 'Rafraîchir',
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAppInfo(context),
          tooltip: 'À propos',
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedIndex != 0) return null;
    
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Météo rafraîchie pour Niamey'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('À propos'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weather App v1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Application météo en temps réel avec prévisions. Données fournies par OpenWeatherMap.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                'Ville par défaut: Niger',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}