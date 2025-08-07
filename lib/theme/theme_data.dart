import 'package:challenge_app_flutter/theme/app_colors.dart';
import 'package:flutter/material.dart';

final ThemeData appDarkBlueTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.highlight,
    background: AppColors.background,
    surface: AppColors.card,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
  ),
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.card,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.card,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    labelStyle: TextStyle(color: AppColors.textSecondary),
    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
  ),
  iconTheme: IconThemeData(color: AppColors.highlight),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.highlight,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: Colors.white),
  ),
);
