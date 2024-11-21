import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.mainColorDark,
      error: AppColors.errorColor,
      onPrimary: AppColors.primaryWhite,
    ),
    scaffoldBackgroundColor: AppColors.primaryDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.mainTextColorDark,
      elevation: 0,
    ),
    cardTheme: const CardTheme(
      color: AppColors.secondaryDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.secTextColorDark,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.mainTextColorDark,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.mainTextColorDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.mainTextColorDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.mainTextColorDark,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.secTextColorDark,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.mainTextColorDark,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryWhite,
      secondary: AppColors.secondaryLight,
      surface: AppColors.mainColorLight,
      error: AppColors.errorColor,
      onPrimary: AppColors.primaryDark,
    ),
    scaffoldBackgroundColor: AppColors.primaryWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.mainTextColorLight,
      elevation: 0,
    ),
    cardTheme: const CardTheme(
      color: AppColors.secondaryLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.secTextColorLight,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.mainTextColorLight,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.mainTextColorLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.mainTextColorLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.mainTextColorLight,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.secTextColorLight,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.mainTextColorLight,
    ),
  );
}
