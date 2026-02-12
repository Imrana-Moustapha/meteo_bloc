import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/favorite/presentation/screens/favorie_screen.dart';
import 'package:meteo/l10n/app_localizations.dart';
import 'package:meteo/settings/presentation/screens/setting_screen.dart';
import 'package:meteo/weather/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/home/presentation/widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContentScreen(),
    const FavoritesScreen(), 
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherBloc>().fetchDefaultWeatherWithForecast();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildAppBar(context, t),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: t.settingsTitle,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? _buildFloatingActionButton(context)
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations t) {
    List<String> titles = [t.weatherTitle, 'Mes Favoris', t.settingsTitle];

    return AppBar(
      title: Text(
        titles[_selectedIndex],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
      backgroundColor: Colors.blue.shade800,
      elevation: 2,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _refreshWeather(context),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.refresh),
    );
  }

  void _refreshWeather(BuildContext context) {
    context.read<WeatherBloc>().add(const RefreshWeatherEvent());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Météo rafraîchie via GPS'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}