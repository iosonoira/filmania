import 'package:flutter/material.dart';

/// AppColors class specifically derived from DESIGN.md tokens.
abstract class AppColors {
  // Brand Colors
  static const primary = Color(0xFF7C4DFF); // Deep Violet
  static const primaryLight = Color(0xFFE1D5FF); // Soft Lavender
  static const tertiary = Color(0xFFFFB688); // Star/Highlight

  // Dark Mode (Default)
  static const backgroundDark = Color(0xFF0F0E13);
  static const surfaceDark = Color(0xFF1B1A23);
  static const onSurfacePrimaryDark = Color(0xFFF5F5F5);
  static const onSurfaceSecondaryDark = Color(0xFF938F99);

  // Light Mode
  static const backgroundLight = Color(0xFFF2F2F7); // Lighter Grey (iOS style)
  static const surfaceLight = Color(0xFFFFFFFF);
  static const onSurfacePrimaryLight = Color(0xFF1C1C1E);
  static const onSurfaceSecondaryLight = Color(0xFF636366);

  // Semantic Utility
  static const error = Color(0xFFCF6679);

  /// Resolves the semantic color scheme based on the current theme brightness.
  ///
  /// Always use this instead of accessing [Theme.of(context).brightness] directly.
  /// Rule: Never access Theme.of(context) to derive semantic colours.
  static AppColorScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _darkScheme : _lightScheme;
  }

  static const _darkScheme = AppColorScheme(
    primary: primary,
    background: backgroundDark,
    surface: surfaceDark,
    onSurfacePrimary: onSurfacePrimaryDark,
    onSurfaceSecondary: onSurfaceSecondaryDark,
    accent: primaryLight,
    error: error,
  );

  static const _lightScheme = AppColorScheme(
    primary: primary,
    background: backgroundLight,
    surface: surfaceLight,
    onSurfacePrimary: onSurfacePrimaryLight,
    onSurfaceSecondary: onSurfaceSecondaryLight,
    accent: primaryLight,
    error: error,
  );
}

/// Helper class to hold a resolved color scheme.
class AppColorScheme {
  final Color primary;
  final Color background;
  final Color surface;
  final Color onSurfacePrimary;
  final Color onSurfaceSecondary;
  final Color accent;
  final Color error;

  const AppColorScheme({
    required this.primary,
    required this.background,
    required this.surface,
    required this.onSurfacePrimary,
    required this.onSurfaceSecondary,
    required this.accent,
    required this.error,
  });

  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primary.withValues(alpha: 0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
