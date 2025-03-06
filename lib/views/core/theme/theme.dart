import 'package:flutter/material.dart';
import 'package:pami/views/core/theme/colors.dart';
import 'package:pami/views/core/theme/text_styles.dart';

/// App's theme
final ThemeData appTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
    onError: AppColors.onError,
  ),
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
  ),
);
