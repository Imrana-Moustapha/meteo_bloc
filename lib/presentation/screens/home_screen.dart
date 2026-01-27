import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/screens/favorie_screen.dart';
import 'package:meteo/presentation/screens/setting_screen.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Météo Niger', // Changé le titre
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
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? _buildFloatingActionButton() : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _refreshWeather(context),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.refresh),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue.shade800,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
    );
  }

  void _refreshWeather(BuildContext context) {
    final weatherBloc = context.read<WeatherBloc>();
    
    // Vérifier si le Bloc existe dans l'arbre widget
    if (!context.mounted) return;
    
    // Utiliser la méthode par défaut du Bloc si elle existe
    // Appeler la méthode refresh ou fetch par défaut
    weatherBloc.add(RefreshWeatherEvent()); // Sans paramètre = Niger par défaut
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Météo rafraîchie pour Niger'),
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

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _currentCity = "Niger"; // CHANGÉ ICI : "Niger" au lieu de "Paris"

  @override
  void initState() {
    super.initState();
    // Charger la météo de Niger au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final weatherBloc = context.read<WeatherBloc>();
        
        // Vérifier si le bloc est déjà initialisé avec des données
        if (weatherBloc.state is! WeatherLoadedState) {
          // Charger Niger par défaut avec prévisions
          weatherBloc.add(FetchWeatherWithForecastEvent(cityName: _currentCity));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        // Mettre à jour le nom de la ville affiché quand les données changent
        if (state is WeatherLoadedState) {
          setState(() {
            _currentCity = state.weather.cityName;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche
            Card(
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
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une ville...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.blue),
                        ),
                        onSubmitted: (value) {
                          _searchWeather(context, value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.blue), // Icône changée
                      onPressed: () {
                        // Retour à Niger par défaut
                        _cityController.clear();
                        _returnToDefaultCity(context);
                      },
                      tooltip: 'Retour à Niger',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Affichage de la météo
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoadingState) {
                    return _buildLoadingWidget();
                  }
                  
                  if (state is WeatherRefreshingState) {
                    return _buildRefreshingWidget(state);
                  }
                  
                  if (state is WeatherErrorState) {
                    return _buildErrorWidget(state.message);
                  }
                  
                  if (state is WeatherLoadedState) {
                    return _buildWeatherWidget(state);
                  }
                  
                  return _buildWelcomeWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchWeather(BuildContext context, String city) {
    if (city.trim().isNotEmpty) {
      _currentCity = city.trim();
      _cityController.clear();
      FocusScope.of(context).unfocus();
      
      // Charger avec prévisions
      context.read<WeatherBloc>().add(FetchWeatherWithForecastEvent(cityName: _currentCity));
    }
  }

  void _returnToDefaultCity(BuildContext context) {
    setState(() {
      _currentCity = "Niger";
      _cityController.clear();
    });
    
    context.read<WeatherBloc>().add(FetchWeatherWithForecastEvent(cityName: "Niger"));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retour à Niger'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _getCurrentLocationWeather(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de localisation à venir'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Chargement de la météo pour Niger...'),
        ],
      ),
    );
  }

  Widget _buildRefreshingWidget(WeatherRefreshingState state) {
    return _buildWeatherContent(state.weather, state.forecasts, isRefreshing: true);
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            onPressed: () {
              context.read<WeatherBloc>().add(FetchWeatherEvent(cityName: _currentCity));
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Retour à Niger'),
            onPressed: () {
              _returnToDefaultCity(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(WeatherLoadedState state) {
    return _buildWeatherContent(state.weather, state.forecasts);
  }

  Widget _buildWeatherContent(WeatherModel weather, List<ForecastModel>? forecasts, {bool isRefreshing = false}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Indicateur de rafraîchissement
          if (isRefreshing)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Mise à jour...',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // Carte principale
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Ville et date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dernière mise à jour: ${_formatTime(weather.lastUpdated)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          _addToFavorites(weather);
                        },
                        tooltip: 'Ajouter aux favoris',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Température et icône
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icône météo
                      Image.network(
                        'http://openweathermap.org/img/wn/${weather.icon}@4x.png',
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getWeatherIcon(weather.condition),
                            size: 100,
                            color: Colors.orange,
                          );
                        },
                      ),
                      
                      // Température
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Informations détaillées
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        Icons.air,
                        'Vent',
                        '${weather.windSpeed.toStringAsFixed(1)} km/h',
                      ),
                      _buildDetailItem(
                        Icons.water_drop,
                        'Humidité',
                        '${weather.humidity}%',
                      ),
                      _buildDetailItem(
                        Icons.thermostat,
                        'Ressenti',
                        '${(weather.temperature - 2).toStringAsFixed(1)}°C',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Prévisions réelles depuis l'API
          if (forecasts != null && forecasts.isNotEmpty)
            _buildRealForecastSection(forecasts),
          
          const SizedBox(height: 20),
          
          // Bouton de rafraîchissement
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Rafraîchir les données'),
              onPressed: () {
                context.read<WeatherBloc>().add(RefreshWeatherEvent(cityName: weather.cityName));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sunny,
            size: 120,
            color: Colors.orange.shade300,
          ),
          const SizedBox(height: 30),
          Text(
            'Météo Niger', // Texte modifié
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Bienvenue ! L\'application affiche la météo de Niger par défaut. Recherchez une autre ville si nécessaire.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: const Text('Rechercher une autre ville'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              // Focus sur le champ de recherche
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Voir Niger'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.blue.shade800,
            ),
            onPressed: () {
              _returnToDefaultCity(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 8),
        Text(
          title,
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

  Widget _buildRealForecastSection(List<ForecastModel> forecasts) {
    // Grouper les prévisions par jour
    final Map<String, List<ForecastModel>> dailyForecasts = {};
    
    for (final forecast in forecasts.take(10)) { // Prendre seulement 10 prévisions
      final date = _formatDate(forecast.date);
      dailyForecasts[date] ??= [];
      dailyForecasts[date]!.add(forecast);
    }
    
    // Prendre 5 jours maximum
    final days = dailyForecasts.keys.take(5).toList();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prévisions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            // Prévisions par jour
            Column(
              children: days.map((day) {
                final dayForecasts = dailyForecasts[day]!;
                final avgTemp = dayForecasts.map((f) => f.temp).reduce((a, b) => a + b) / dayForecasts.length;
                final maxTemp = dayForecasts.map((f) => f.tempMax).reduce((a, b) => a > b ? a : b);
                final minTemp = dayForecasts.map((f) => f.tempMin).reduce((a, b) => a < b ? a : b);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (dayForecasts.isNotEmpty)
                        Image.network(
                          'http://openweathermap.org/img/wn/${dayForecasts.first.icon}.png',
                          width: 30,
                          height: 30,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        '${maxTemp.toStringAsFixed(0)}° / ${minTemp.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _addToFavorites(WeatherModel weather) {
    // TODO: Implémenter l'ajout aux favoris
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${weather.cityName} ajouté aux favoris'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDay = DateTime(date.year, date.month, date.day);
    
    if (forecastDay == today) return 'Aujourd\'hui';
    if (forecastDay == today.add(const Duration(days: 1))) return 'Demain';
    
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[date.weekday - 1];
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.contains('nuageux')) return Icons.cloud;
    if (condition.contains('pluie')) return Icons.water_drop;
    if (condition.contains('neige')) return Icons.ac_unit;
    if (condition.contains('orage')) return Icons.flash_on;
    return Icons.sunny;
  }
}