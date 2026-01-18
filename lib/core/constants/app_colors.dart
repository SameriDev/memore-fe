import 'package:flutter/material.dart';

/// App color constants based on memore's design system
/// Primary color: Purple #6366F1 (memore brand color)
class AppColors {
  AppColors._();

  // Primary Colors - memore Purple Theme
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryVariant = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF8B87FF);
  static const Color primaryDark = Color(0xFF3730A3);

  // Background Colors - Material Design 3
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFF7F2FA);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF3EDF7);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Neutral Colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // State Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color warning = Color(0xFFFF8C00);
  static const Color warningContainer = Color(0xFFFFE4CC);

  static const Color success = Color(0xFF00C851);
  static const Color successContainer = Color(0xFFCCFFDD);

  // Camera Interface Colors
  static const Color cameraBackground = Color(0xFF000000);
  static const Color cameraOverlay = Color(0x80000000);
  static const Color captureButton = Color(0xFFFFFFFF);
  static const Color captureButtonPressed = Color(0xFFE0E0E0);

  // Friend Status Colors
  static const Color friendOnline = Color(0xFF4CAF50);
  static const Color friendOffline = Color(0xFF9E9E9E);
  static const Color friendBusy = Color(0xFFF44336);

  // Widget Colors (for home screen widgets)
  static const Color widgetBackground = Color(0xFFFAFAFA);
  static const Color widgetBorder = Color(0xFFE1E1E1);
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

  // Dark Theme Colors (for future dark mode support)
  static const Color darkBackground = Color(0xFF10121B);
  static const Color darkSurface = Color(0xFF1C1F26);
  static const Color darkOnBackground = Color(0xFFE6E0E9);
  static const Color darkOnSurface = Color(0xFFE6E0E9);

  // Semi-transparent colors for overlays
  static const Color black50 = Color(0x80000000);
  static const Color black25 = Color(0x40000000);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white25 = Color(0x40FFFFFF);
}
