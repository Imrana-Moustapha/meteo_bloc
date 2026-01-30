import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meteo/core/services/hive_service.dart';
import 'package:meteo/core/themes/app_themes.dart';
import 'package:meteo/data/repositories/favorite_repository.dart';
import 'package:meteo/data/repositories/weather_repository.dart';
import 'package:meteo/presentation/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:meteo/presentation/blocs/weather_bloc/weather_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/loacal_cubit.dart';
import 'package:meteo/presentation/cubit/local_cubit/loacal_state.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:meteo/presentation/cubit/theme_cubit/theme_state.dart';
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
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(WeatherRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(FavoriteRepository()),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Metéo',
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: _getThemeMode(themeState),
                locale: Locale(localeState.languageCode),
                supportedLocales: const [
                  Locale('fr', 'FR'), // Français
                  Locale('en', 'US'), // Anglais
                  Locale('ar', 'SA'), // Arabe
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                initialRoute: '/',
                routes: {
                  '/': (context) => const SplashScreen(),
                  '/home': (context) => const HomeScreen(), 
                  '/favorites': (context) => const FavoritesScreen(),
                  '/settings': (context) => const SettingsScreen(), 
                },
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemeState state) {
    switch (state.themeMode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
      // ignore: unreachable_switch_default
      default:
        return ThemeMode.system;
    }
  }
}