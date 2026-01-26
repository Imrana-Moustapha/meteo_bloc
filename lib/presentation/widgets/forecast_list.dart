import 'package:flutter/material.dart';
import 'package:meteo/core/utils/extensions.dart';
import 'package:meteo/core/widgets/custom_widgets.dart';
import 'package:meteo/domain/entities/forecast.dart';

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  final bool showDaily;

  const ForecastList({
    super.key,
    required this.forecasts,
    this.showDaily = false,
  });

  @override
  Widget build(BuildContext context) {
    final filteredForecasts = showDaily
        ? _getDailyForecasts(forecasts)
        : forecasts.take(24); // Limiter à 24h pour les prévisions horaires

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            showDaily ? 'Prévisions sur 7 jours' : 'Prévisions horaires',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...filteredForecasts.map((forecast) => _buildForecastItem(context, forecast)),
      ],
    );
  }

  Widget _buildForecastItem(BuildContext context, Forecast forecast) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showDaily ? forecast.dayOfWeek : forecast.formattedTime,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  forecast.description.capitalize(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          WeatherIconWidget(
            iconCode: forecast.iconCode,
            size: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                forecast.formattedTemperature,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (forecast.pop != null && forecast.pop! > 0) ...[
                const SizedBox(height: 4),
                Text(
                  forecast.formattedPop,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<Forecast> _getDailyForecasts(List<Forecast> forecasts) {
    final dailyForecasts = <Forecast>[];
    final days = <String>{};
    
    for (final forecast in forecasts) {
      final dayKey = forecast.dateTime.format('yyyy-MM-dd');
      if (!days.contains(dayKey)) {
        days.add(dayKey);
        dailyForecasts.add(forecast);
      }
      
      if (dailyForecasts.length >= 7) break;
    }
    
    return dailyForecasts;
  }
}