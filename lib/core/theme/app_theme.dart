import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App Theme Configuration based on COMPONENTDETAILS.md
class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(primary: AppColors.lightPrimary, secondary: AppColors.lightSecondary, surface: AppColors.lightSurface, error: AppColors.error),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightPrimary, foregroundColor: Colors.white, elevation: 0, centerTitle: false),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    textTheme: const TextTheme(
      // Heading: 18-20sp, Bold
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightText),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.lightText),
      // Body: 14-16sp, Regular
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.lightText),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.lightText),
      // Caption: 12sp, Light
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.lightTextSecondary),
      // Button: 14sp, Medium
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.lightSecondary, foregroundColor: Colors.white),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: AppColors.lightSurface, selectedItemColor: AppColors.lightPrimary, unselectedItemColor: AppColors.lightTextSecondary, type: BottomNavigationBarType.fixed, elevation: 8),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(primary: AppColors.darkPrimary, secondary: AppColors.darkSecondary, surface: AppColors.darkSurface, error: AppColors.error),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkSurface, foregroundColor: AppColors.darkText, elevation: 0, centerTitle: false),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText),
      headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.darkText),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.darkText),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.darkTextSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.darkSecondary, foregroundColor: AppColors.darkText),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: AppColors.darkSurface, selectedItemColor: AppColors.darkPrimary, unselectedItemColor: AppColors.darkTextSecondary, type: BottomNavigationBarType.fixed, elevation: 8),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
