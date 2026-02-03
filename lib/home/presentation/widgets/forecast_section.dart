import 'package:flutter/material.dart';
import 'package:meteo/forecast/data/models/forecast_model.dart';
import 'package:meteo/l10n/app_localizations.dart';

class ForecastSection extends StatefulWidget {
  final List<ForecastModel> forecasts;

  const ForecastSection({super.key, required this.forecasts});

  @override
  State<ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<ForecastSection> {
  @override
  Widget build(BuildContext context) {
    // On utilise "widget.forecasts" pour accéder à la liste
    final dailyForecasts = _groupForecastsByDay(widget.forecasts);
    final days = dailyForecasts.keys.take(5).toList();
    final t = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.weatherTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Column(
              children: days.map((day) {
                final dayForecasts = dailyForecasts[day]!;
                final maxTemp = dayForecasts
                    .map((f) => f.tempMax)
                    .reduce((a, b) => a > b ? a : b);
                final minTemp = dayForecasts
                    .map((f) => f.tempMin)
                    .reduce((a, b) => a < b ? a : b);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          day,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (dayForecasts.isNotEmpty)
                        Image.network(
                          'http://openweathermap.org/img/wn/${dayForecasts.first.icon}.png',
                          width: 30,
                          height: 30,
                          // Petit ajout pour éviter les erreurs de chargement d'image
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.wb_cloudy_outlined, size: 20),
                        ),
                      const SizedBox(width: 10),
                      Text(
                        '${maxTemp.toStringAsFixed(0)}° / ${minTemp.toStringAsFixed(0)}°',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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

  // Les fonctions utilitaires restent à l'intérieur de la classe State
  Map<String, List<ForecastModel>> _groupForecastsByDay(
    List<ForecastModel> forecasts,
  ) {
    final Map<String, List<ForecastModel>> dailyForecasts = {};

    for (final forecast in forecasts.take(10)) {
      final date = _formatDate(forecast.date);
      dailyForecasts[date] ??= [];
      dailyForecasts[date]!.add(forecast);
    }

    return dailyForecasts;
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
}