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
    final dailyForecasts = _groupForecastsByDay(widget.forecasts);
    // On prend les 5 prochains jours
    final days = dailyForecasts.keys.take(5).toList();
    final t = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.weatherTitle, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Liste des jours
            ...days.map((day) {
              final dayForecasts = dailyForecasts[day]!;
              
              // Calcul des températures min/max de la journée
              final maxTemp = dayForecasts
                  .map((f) => f.tempMax)
                  .reduce((a, b) => a > b ? a : b);
              final minTemp = dayForecasts
                  .map((f) => f.tempMin)
                  .reduce((a, b) => a < b ? a : b);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    // Jour de la semaine (Flexible pour éviter l'overflow)
                    Expanded(
                      flex: 3,
                      child: Text(
                        day,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Icône météo centrale
                    Expanded(
                      flex: 2,
                      child: dayForecasts.isNotEmpty
                          ? Center(
                              child: Image.network(
                                'http://openweathermap.org/img/wn/${dayForecasts.first.icon}.png',
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.wb_cloudy_outlined, size: 20),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Températures Min / Max alignées à droite
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${maxTemp.toStringAsFixed(0)}° / ${minTemp.toStringAsFixed(0)}°',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Groupe les données brutes par jour calendrier
  Map<String, List<ForecastModel>> _groupForecastsByDay(
    List<ForecastModel> forecasts,
  ) {
    final Map<String, List<ForecastModel>> dailyForecasts = {};

    for (final forecast in forecasts) {
      final dateLabel = _formatDate(forecast.date);
      dailyForecasts[dateLabel] ??= [];
      dailyForecasts[dateLabel]!.add(forecast);
    }

    return dailyForecasts;
  }

  String _formatDate(DateTime date) {
    final t = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDay = DateTime(date.year, date.month, date.day);

    if (forecastDay == today) return t.weatherAujourdhui;
    if (forecastDay == today.add(const Duration(days: 1))) return t.weatherDemain;

    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[date.weekday - 1];
  }
}