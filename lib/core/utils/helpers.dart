import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteo/core/utils/extensions.dart';

class Helpers {
  // Validation d'email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Validation de mot de passe
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Formatage de la distance
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  // Calcul de la distance entre deux coordonnées
  static double calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2,
  ) {
    const earthRadius = 6371000.0; // en mètres

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Vérification de la connectivité
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Délai avec délai exponentiel
  static Future<void> exponentialBackoff(
    Future<void> Function() action,
    int maxRetries,
  ) async {
    for (var i = 0; i < maxRetries; i++) {
      try {
        await action();
        return;
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: pow(2, i).toInt()));
      }
    }
  }

  // Génération d'un ID unique
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // Formatage du temps écoulé
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Il y a $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Il y a $hours heure${hours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Il y a $days jour${days > 1 ? 's' : ''}';
    } else {
      return date.format('dd/MM/yyyy');
    }
  }

  // Extraction des initiales
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    } else {
      return name.toUpperCase();
    }
  }

  // Conversion hex vers Color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    
    return Color(int.parse(hex, radix: 16));
  }

  // Vérification des permissions de localisation
  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Obfuscation partielle d'email
  static String obfuscateEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }
    
    return '${username.substring(0, 2)}***@$domain';
  }

  // Compression de liste (suppression des doublons)
  static List<T> deduplicate<T>(List<T> list) {
    return list.toSet().toList();
  }

  // Groupement par date
  static Map<String, List<T>> groupByDate<T>(
    List<T> items,
    DateTime Function(T) dateExtractor,
  ) {
    final Map<String, List<T>> grouped = {};
    
    for (final item in items) {
      final date = dateExtractor(item);
      final key = date.format('yyyy-MM-dd');
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      
      grouped[key]!.add(item);
    }
    
    return grouped;
  }
}