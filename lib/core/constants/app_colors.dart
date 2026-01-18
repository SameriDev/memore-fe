import 'package:flutter/material.dart';

/// App color constants based on memore's design system
/// Primary color: Brown #8B4513 (memore brand color - matching camera icon)
class AppColors {
  AppColors._();

  // Primary Colors - memore Brown/Tan Theme
  static const Color primary = Color(0xFF8B4513); // SaddleBrown
  static const Color primaryVariant = Color(0xFFA0522D); // Sienna
  static const Color primaryLight = Color(0xFFCD853F); // Peru
  static const Color primaryDark = Color(0xFF654321); // DarkBrown

  // Background Colors - Warm Brown/Tan Theme
  static const Color background = Color(0xFFFDF5E6); // OldLace - warm white
  static const Color surface = Color(0xFFF5DEB3); // Wheat - light tan
  static const Color surfaceVariant = Color(
    0xFFDEB887,
  ); // BurlyWood - medium tan
  static const Color surfaceContainerLowest = Color(0xFFFDF5E6);
  static const Color surfaceContainer = Color(
    0xFFF0E68C,
  ); // Khaki - soft container

  // Text Colors - Brown Theme
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on brown
  static const Color onBackground = Color(
    0xFF3E2723,
  ); // Dark brown for main text
  static const Color onSurface = Color(
    0xFF3E2723,
  ); // Dark brown for surface text
  static const Color onSurfaceVariant = Color(
    0xFF5D4037,
  ); // Medium brown for secondary text

  // Neutral Colors - Brown Theme
  static const Color outline = Color(0xFF8D6E63); // Medium brown for borders
  static const Color outlineVariant = Color(
    0xFFBCAAA4,
  ); // Light brown for subtle borders

  // State Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color warning = Color(
    0xFFD2691E,
  ); // Chocolate - complements brown theme
  static const Color warningContainer = Color(
    0xFFFFF8DC,
  ); // Cornsilk - warm warning container

  static const Color success = Color(0xFF00C851);
  static const Color successContainer = Color(0xFFCCFFDD);

  // Camera Interface Colors
  static const Color cameraBackground = darkBackground; // Use dark brown theme
  static const Color cameraOverlay = Color(0x80000000);
  static const Color captureButton = Color(0xFFFFFFFF);
  static const Color captureButtonPressed = Color(0xFFE0E0E0);

  // Friend Status Colors
  static const Color friendOnline = Color(0xFF4CAF50);
  static const Color friendOffline = Color(0xFF9E9E9E);
  static const Color friendBusy = Color(0xFFF44336);

  // Widget Colors (for home screen widgets) - Brown Theme
  static const Color widgetBackground = Color(
    0xFFF5F5DC,
  ); // Beige - warm widget background
  static const Color widgetBorder = Color(0xFFD2B48C); // Tan - warm border
  static const Color widgetShadow = Color(0x1A000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dark Theme Colors - Brown Theme
  static const Color darkBackground = Color(
    0xFF3E2723,
  ); // Dark brown background
  static const Color darkSurface = Color(
    0xFF4E342E,
  ); // Medium dark brown surface
  static const Color darkOnBackground = Color(0xFFF5DEB3); // Wheat text on dark
  static const Color darkOnSurface = Color(
    0xFFF5DEB3,
  ); // Wheat text on dark surface

  // Additional brown theme colors for comprehensive coverage
  static const Color accentGold = Color(0xFFCD853F); // Peru - brown-gold accent
  static const Color textSecondary = Color(
    0xFF8D6E63,
  ); // Medium brown for secondary text
  static const Color borderSubtle = Color(0xFFD2B48C); // Tan for subtle borders
  static const Color surfaceTinted = Color(
    0xFFF5F5DC,
  ); // Beige for tinted surfaces
  static const Color overlayDark = Color(0x803E2723); // Dark brown overlay
  static const Color overlayLight = Color(0x40DEB887); // Light brown overlay

  // Semi-transparent colors for overlays
  static const Color black50 = Color(0x80000000);
  static const Color black25 = Color(0x40000000);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white25 = Color(0x40FFFFFF);
}
