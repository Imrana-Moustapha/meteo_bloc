import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF2196F3),
    primaryColorLight: const Color(0xFF64B5F6),
    primaryColorDark: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF2196F3),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF4CAF50),
      background: Color(0xFFF5F5F5),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    cardTheme:  CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF2196F3),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2196F3)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF2196F3)),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF2196F3),
    primaryColorLight: const Color(0xFF64B5F6),
    primaryColorDark: const Color(0xFF1976D2),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF4CAF50),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
      color: const Color(0xFF1E1E1E),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF2196F3),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.white),
      displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w300, color: Colors.white),
      displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2196F3)),
      ),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF2196F3)),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF424242),
      thickness: 1,
      space: 1,
    ),
  );

  static Color getWeatherColor(int conditionId) {
    // Group 2xx: Thunderstorm
    if (conditionId >= 200 && conditionId < 300) return const Color(0xFF9C27B0);
    // Group 3xx: Drizzle
    if (conditionId >= 300 && conditionId < 400) return const Color(0xFF03A9F4);
    // Group 5xx: Rain
    if (conditionId >= 500 && conditionId < 600) return const Color(0xFF2196F3);
    // Group 6xx: Snow
    if (conditionId >= 600 && conditionId < 700) return const Color(0xFF00BCD4);
    // Group 7xx: Atmosphere
    if (conditionId >= 700 && conditionId < 800) return const Color(0xFF9E9E9E);
    // Group 800: Clear
    if (conditionId == 800) return const Color(0xFFFF9800);
    // Group 80x: Clouds
    if (conditionId >= 801 && conditionId < 900) return const Color(0xFF607D8B);
    
    return const Color(0xFF2196F3);
  }
}