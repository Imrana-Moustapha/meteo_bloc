import 'package:flutter/material.dart';
import 'package:meteo/data/models/forecast_model.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const ForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final dailyForecasts = _groupForecastsByDay(forecasts);
    final days = dailyForecasts.keys.take(5).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prévisions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      Expanded(
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
