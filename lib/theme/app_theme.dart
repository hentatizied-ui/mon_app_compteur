import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryColor = Color(0xFF1E88E5);  // Bleu
  static const Color secondaryColor = Color(0xFF43A047); // Vert
  static const Color accentColor = Color(0xFFFFA000);    // Orange
  static const Color dangerColor = Color(0xFFE53935);    // Rouge
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris clair
  
  // Thème clair
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      error: dangerColor,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
  
  // Thème sombre (optionnel)
  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    useMaterial3: true,
  );
}