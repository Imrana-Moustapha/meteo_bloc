import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Attendre 5 secondes puis naviguer vers l'écran principal
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Fond léger bleu ciel
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Grande icône météo
            Icon(
              Icons.wb_sunny, // Icône soleil
              size: 150, // Taille très grande
              color: Colors.orange, // Couleur orange comme le soleil
            ),
            
            SizedBox(height: 20),
            
            // Nom de l'application
            Text(
              'WeatherApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            
            SizedBox(height: 10),
            
            // Sous-titre
            Text(
              'Votre météo en temps réel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
