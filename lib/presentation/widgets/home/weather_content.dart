import 'package:flutter/material.dart';
import 'package:meteo/data/models/forecast_model.dart';
import 'package:meteo/data/models/weather_model.dart';
import 'package:meteo/presentation/widgets/home/forecast_section.dart';
import 'package:meteo/presentation/widgets/home/detail_item.dart';

class WeatherContent extends StatelessWidget {
  final WeatherModel weather;
  final List<ForecastModel>? forecasts;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onAddToFavorites;

  const WeatherContent({
    super.key,
    required this.weather,
    this.forecasts,
    this.isRefreshing = false,
    required this.onRefresh,
    required this.onAddToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isRefreshing) _buildRefreshingIndicator(),
          
          _buildMainCard(),
          
          const SizedBox(height: 20),
          
          if (forecasts != null && forecasts!.isNotEmpty)
            ForecastSection(forecasts: forecasts!),
          
          const SizedBox(height: 20),
          
          // _buildRefreshButton(context),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRefreshingIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      // ignore: deprecated_member_use
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
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildCityHeader(),
            
            const SizedBox(height: 20),
            
            _buildTemperatureSection(),
            
            const SizedBox(height: 30),
            
            _buildDetailsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCityHeader() {
    return Row(
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
          onPressed: onAddToFavorites,
          tooltip: 'Ajouter aux favoris',
        ),
      ],
    );
  }

  Widget _buildTemperatureSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icône météo
        _buildWeatherIcon(),
        
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
    );
  }

  Widget _buildWeatherIcon() {
    return Image.network(
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
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DetailItem(
          icon: Icons.air,
          title: 'Vent',
          value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
        ),
        DetailItem(
          icon: Icons.water_drop,
          title: 'Humidité',
          value: '${weather.humidity}%',
        ),
        DetailItem(
          icon: Icons.thermostat,
          title: 'Ressenti',
          value: '${(weather.temperature - 2).toStringAsFixed(1)}°C',
        ),
      ],
    );
  }

  // Widget _buildRefreshButton(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: ElevatedButton.icon(
  //       icon: const Icon(Icons.refresh),
  //       label: const Text('Rafraîchir les données'),
  //       onPressed: onRefresh,
  //       style: ElevatedButton.styleFrom(
  //         minimumSize: const Size(double.infinity, 50),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(25),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('nuageux')) return Icons.cloud;
    if (condition.toLowerCase().contains('pluie')) return Icons.water_drop;
    if (condition.toLowerCase().contains('neige')) return Icons.ac_unit;
    if (condition.toLowerCase().contains('orage')) return Icons.flash_on;
    return Icons.sunny;
  }
}