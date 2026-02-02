import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Importations des services et repositories
import 'package:meteo/core/services/hive_service.dart';
import 'package:meteo/core/themes/app_themes.dart';
import 'package:meteo/data/repositories/favorite_repository.dart';
import 'package:meteo/data/repositories/weather_repository.dart';

// Importations des Blocs et Cubits
import 'package:meteo/presentation/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/local_state.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';

// Importation cruciale pour la traduction
import 'package:meteo/l10n/app_localizations.dart'; 

// Importations des écrans
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
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => WeatherBloc(WeatherRepository())),
        BlocProvider(create: (context) => FavoriteBloc(FavoriteRepository())),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Metéo',
                debugShowCheckedModeBanner: false,
                
                // Thèmes
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: _getThemeMode(themeState),
                
                // Localisation pilotée par le Cubit
                locale: Locale(localeState.languageCode),
                
                // Utilise les locales définies dans tes fichiers .arb
                supportedLocales: AppLocalizations.supportedLocales,
                
                // Délégués pour gérer les traductions et la direction RTL
                localizationsDelegates: const [
                  AppLocalizations.delegate, // Ton fichier généré
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                
                // Navigation
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  '/home': (context) => const HomeScreen(),
                  '/favorites': (context) => const FavoritesScreen(),
                  '/settings': (context) => const SettingsScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }

  // Gestion simplifiée du mode de thème
  ThemeMode _getThemeMode(ThemeState state) {
    switch (state.themeMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}