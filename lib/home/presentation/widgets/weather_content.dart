import 'package:flutter/material.dart';
import 'package:meteo/forecast/data/models/forecast_model.dart';
import 'package:meteo/weather/data/models/weather_model.dart';
import 'package:meteo/l10n/app_localizations.dart';
import 'package:meteo/home/presentation/widgets/forecast_section.dart';
import 'package:meteo/home/presentation/widgets/detail_item.dart';

class WeatherContent extends StatefulWidget {
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
  State<WeatherContent> createState() => _WeatherContentState();
}

class _WeatherContentState extends State<WeatherContent> {
  // Tu pourrais ajouter ici une variable d'état locale, 
  // par exemple : bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.isRefreshing) _buildRefreshingIndicator(),
          _buildMainCard(context),
          const SizedBox(height: 20),
          if (widget.forecasts != null && widget.forecasts!.isNotEmpty)
            ForecastSection(forecasts: widget.forecasts!),
          const SizedBox(height: 20),
          Text(
            t?.lastUpdate(_formatTime(widget.weather.lastUpdated)) ?? 'Dernière mise à jour',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRefreshingIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blue.withOpacity(0.1),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 10),
          Text('Mise à jour...', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.weather.cityName, 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: widget.onAddToFavorites,
                  tooltip: t?.addToFavorites ?? 'Ajouter aux favoris',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTemperatureSection(),
            const SizedBox(height: 30),
            _buildDetailsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureSection() {
    return Column(
      children: [
        Icon(
          _getWeatherIcon(widget.weather.condition), 
          size: 80, 
          color: Colors.orange
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.weather.temperature.toStringAsFixed(1)}°C', 
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300)
        ),
        Text(
          widget.weather.condition.toUpperCase(), 
          style: const TextStyle(fontSize: 18, color: Colors.grey)
        ),
      ],
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DetailItem(
          icon: Icons.air, 
          title: t?.windSpeed ?? 'Vent', 
          value: '${widget.weather.windSpeed.toStringAsFixed(1)} km/h'
        ),
        DetailItem(
          icon: Icons.water_drop, 
          title: t?.humidity ?? 'Humidité', 
          value: '${widget.weather.humidity}%'
        ),
        DetailItem(
          icon: Icons.thermostat, 
          title: t?.feelsLike ?? 'Ressenti', 
          value: '${(widget.weather.temperature - 2).toStringAsFixed(1)}°C'
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('nuageux')) return Icons.cloud;
    if (lowerCondition.contains('pluie')) return Icons.water_drop;
    return Icons.sunny;
  }
}