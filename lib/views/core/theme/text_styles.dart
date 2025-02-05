import 'package:flutter/material.dart';
import 'package:pami/views/core/theme/colors.dart';

/// Helper class to define app's text styles
class AppTextStyles {
  /// Style for large display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  /// Style for headlines
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  /// Style for body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.onBackground,
  );

  /// Smaller style for body text
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
  );
}
