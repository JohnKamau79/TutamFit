import 'package:flutter/material.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.deepNavy,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.deepNavy,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.deepNavy,
      selectedItemColor: AppColors.limeGreen,
      unselectedItemColor: AppColors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkGray),
      titleMedium: TextStyle(color: AppColors.darkGray),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.deepNavy,
    scaffoldBackgroundColor: AppColors.darkGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.deepNavy,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.deepNavy,
      selectedItemColor: AppColors.limeGreen,
      unselectedItemColor: AppColors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.deepNavy,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.white),
      titleMedium: TextStyle(color: AppColors.white),
    ),
  );
}
