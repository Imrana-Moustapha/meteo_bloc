import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:meteo/core/constants/api_constants.dart';
import 'package:meteo/core/constants/app_constants.dart';
import 'package:meteo/core/themes/app_theme.dart';
import 'package:meteo/data/datasources/local/hive_service.dart';
import 'package:meteo/data/datasources/local/local_datasource.dart';
import 'package:meteo/data/datasources/remote/remote_datasource.dart';
import 'package:meteo/data/datasources/remote/weather_api_service.dart';
import 'package:meteo/data/repositories/weather_repository_impl.dart';
import 'package:meteo/domain/usecases/get_forecast.dart';
import 'package:meteo/domain/usecases/get_weather.dart';
import 'package:meteo/domain/usecases/manage_favorites.dart';
import 'package:meteo/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/bloc/setting_bloc/settings_bloc.dart';
import 'package:meteo/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/screens/favorie_screen.dart';
import 'package:meteo/presentation/screens/home_screen.dart';
import 'package:meteo/presentation/screens/search_screen.dart';
import 'package:meteo/presentation/screens/setting_screen.dart';
import 'package:meteo/presentation/screens/weather_detail_screen.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late WeatherRepositoryImpl repository;
  late LocalDataSource localDataSource;
  late RemoteDataSource remoteDataSource;
  late WeatherApiService weatherApiService;
  bool _initialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialiser Hive (doit être fait avant d'utiliser LocalDataSource)
      await HiveService.init();

      // Initialiser les services API
      weatherApiService = WeatherApiService(
        client: http.Client(),
        baseUrl: ApiConstants.openWeatherBaseUrl,
        apiKey: ApiConstants.openWeatherApiKey,
      );

      // Initialiser les data sources
      remoteDataSource = RemoteDataSourceImpl(
        weatherApiService: weatherApiService,
      );

      localDataSource = LocalDataSourceImpl();

      // Initialiser le repository
      repository = WeatherRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _initialized = true; // Marquer comme initialisé pour afficher l'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un écran de chargement pendant l'initialisation
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  AppStrings.loading, // Utilisez AppStrings ici aussi
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Afficher une erreur si l'initialisation a échoué
    if (_errorMessage != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.error,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _initializeServices,
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        // Bloc pour la météo
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(
            getWeather: GetWeather(repository),
            getForecast: GetForecast(repository),
          ),
        ),
        
        // Bloc pour les favoris
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(
            manageFavorites: ManageFavorites(repository),
          ),
        ),
        
        // Bloc pour les paramètres
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(repository: repository),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
            locale: Locale(settingsState.languageCode),
            routes: {
              AppConstants.homeRoute: (context) => const HomeScreen(),
              AppConstants.favoritesRoute: (context) => const FavoriteScreen(),
              AppConstants.settingsRoute: (context) => const SettingsScreen(),
              AppConstants.searchRoute: (context) => const SearchScreen(),
              AppConstants.detailRoute: (context) => const WeatherDetailScreen(),
            },
            initialRoute: AppConstants.homeRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Nettoyer les ressources
    weatherApiService.close();
    HiveService.closeAllBoxes();
    super.dispose();
  }
}