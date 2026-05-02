import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppSpacing class based on the 8dp grid system mentioned in DESIGN.md.
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static const double radius = 24.0;
}

enum AppThemeMode {
  light,
  dark,
  pureBlack,
}

/// AppTheme class that generates ThemeData based on DESIGN.md rules.
abstract class AppTheme {
  static ThemeData light() => _build(AppThemeMode.light);
  static ThemeData dark() => _build(AppThemeMode.dark);
  static ThemeData pureBlack() => _build(AppThemeMode.pureBlack);

  static ThemeData _build(AppThemeMode mode) {
    final isDark = mode != AppThemeMode.light;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    
    final Color backgroundColor;
    final Color surfaceColor;

    switch (mode) {
      case AppThemeMode.light:
        backgroundColor = AppColors.backgroundLight;
        surfaceColor = AppColors.surfaceLight;
        break;
      case AppThemeMode.dark:
        backgroundColor = AppColors.backgroundDark;
        surfaceColor = AppColors.surfaceDark;
        break;
      case AppThemeMode.pureBlack:
        backgroundColor = AppColors.backgroundPureBlack;
        surfaceColor = AppColors.surfacePureBlack;
        break;
    }
    const primaryColor = AppColors.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Inter', // Body and Labels default
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        brightness: brightness,
        surface: surfaceColor,
        surfaceContainerHighest: isDark ? const Color(0xFF2A2931) : const Color(0xFFF0F0F0),
      ),
      
      // Typography pairing: Manrope for headlines, Inter for body
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w800),
        displayMedium: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w800),
        displaySmall: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w800),
        headlineLarge: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontFamily: 'Inter'),
        bodyMedium: TextStyle(fontFamily: 'Inter'),
        bodySmall: TextStyle(fontFamily: 'Inter'),
      ),

      // Components styling (Rule: 24dp radius and "No-Line" policy)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2931) : const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + AppSpacing.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md + AppSpacing.xs,
            horizontal: AppSpacing.xl,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
