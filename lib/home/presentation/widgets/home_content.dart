import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/weather/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/home/presentation/widgets/search_bar.dart';
import 'package:meteo/home/presentation/widgets/state_widgets.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final TextEditingController _cityController = TextEditingController();
  String? _currentCity; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final weatherBloc = context.read<WeatherBloc>();

        if (weatherBloc.state is! WeatherLoadedState) {
          weatherBloc.add(
            const FetchWeatherWithForecastEvent(cityName: null),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
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
            SearchBarWidget(
              controller: _cityController,
              currentCity: _currentCity ?? "",
              onSearch: (city) => _searchWeather(context, city),
              onReturnToDefault: () => _returnToGPS(context),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  return StateWidgets.build(
                    context: context,
                    state: state,
                    currentCity: _currentCity ?? "",
                    onRefresh: () => _refreshWeather(context),
                    onReturnToDefault: () => _returnToGPS(context),
                  );
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

      context.read<WeatherBloc>().add(
        FetchWeatherWithForecastEvent(cityName: _currentCity),
      );
    }
  }

  void _returnToGPS(BuildContext context) {
    setState(() {
      _currentCity = null;
      _cityController.clear();
    });

    context.read<WeatherBloc>().add(
      const FetchWeatherWithForecastEvent(cityName: null),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Détection de votre position...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _refreshWeather(BuildContext context) {
    context.read<WeatherBloc>().add(
      RefreshWeatherEvent(cityName: _currentCity),
    );
  }
}