import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meteo/app/app.dart';
import 'package:meteo/data/datasources/local/hive_service.dart';

Future<void> main() async {
  // Initialiser les services
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: '.env');
  
  // Initialiser Hive
  await HiveService.init();
  
  runApp(const WeatherApp());
}

