import 'package:flutter/material.dart';
import 'package:meteo/core/themes/app_theme.dart';
import 'package:meteo/core/utils/extensions.dart';
import 'package:meteo/core/widgets/custom_widgets.dart';
import 'package:meteo/domain/entities/weather.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = ModalRoute.of(context)?.settings.arguments as Weather?;
    
    if (weather == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détails'),
        ),
        body: const Center(
          child: Text('Données météo non disponibles'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails météo'),
      ),
      body: _buildContent(context, weather),
    );
  }

  Widget _buildContent(BuildContext context, Weather weather) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentWeather(context, weather),
          const SizedBox(height: 24),
          _buildWeatherDetails(context, weather),
          const SizedBox(height: 24),
          _buildSunInfo(context, weather),
          const SizedBox(height: 24),
          _buildWindInfo(context, weather),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather(BuildContext context, Weather weather) {
    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.location,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.description.capitalize(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              WeatherIconWidget(
                iconCode: weather.iconCode,
                size: 80,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weather.formattedTemperature,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getWeatherColor(weather.conditionId),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Ressenti ${weather.feelsLike.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(BuildContext context, Weather weather) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.water_drop,
            'Humidité',
            '${weather.humidity}%',
          ),
          _buildDetailRow(
            context,
            Icons.speed,
            'Pression',
            '${weather.pressure} hPa',
          ),
          if (weather.visibility != null)
            _buildDetailRow(
              context,
              Icons.visibility,
              'Visibilité',
              '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
            ),
          if (weather.cloudiness != null)
            _buildDetailRow(
              context,
              Icons.cloud,
              'Couverture nuageuse',
              '${weather.cloudiness}%',
            ),
          if (weather.tempMin != null && weather.tempMax != null)
            _buildDetailRow(
              context,
              Icons.thermostat,
              'Min/Max',
              '${weather.tempMin!.toStringAsFixed(1)}°C / ${weather.tempMax!.toStringAsFixed(1)}°C',
            ),
        ],
      ),
    );
  }

  Widget _buildSunInfo(BuildContext context, Weather weather) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soleil',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (weather.sunrise != null && weather.sunset != null)
            Column(
              children: [
                _buildSunRow(
                  context,
                  Icons.wb_sunny,
                  'Lever du soleil',
                  weather.formattedSunrise!,
                ),
                _buildSunRow(
                  context,
                  Icons.nightlight_round,
                  'Coucher du soleil',
                  weather.formattedSunset!,
                ),
              ],
            )
          else
            Text(
              'Données non disponibles',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }

  Widget _buildWindInfo(BuildContext context, Weather weather) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vent',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.air,
            'Vitesse',
            '${weather.windSpeed.toStringAsFixed(1)} km/h',
          ),
          _buildDetailRow(
            context,
            Icons.explore,
            'Direction',
            '${weather.windDirection} (${weather.windDegree}°)',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunRow(
    BuildContext context,
    IconData icon,
    String label,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}