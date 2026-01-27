import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meteo/core/services/hive_service.dart';
import 'package:meteo/data/repositories/favorite_repository.dart';
import 'package:meteo/data/repositories/weather_repository.dart';
import 'package:meteo/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/screens/favorie_screen.dart';
import 'package:meteo/presentation/screens/home_screen.dart';
import 'package:meteo/presentation/screens/setting_screen.dart';
import 'package:meteo/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await HiveService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(WeatherRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(FavoriteRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Metéo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(), 
          '/favorites': (context) => const FavoritesScreen(),
          '/settings': (context) => const SettingsScreen(), 
        },
      ),
    );
  }
}
