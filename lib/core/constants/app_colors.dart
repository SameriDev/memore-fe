import 'package:flutter/material.dart';

/// App color constants based on modern design system
/// Primary color: Modern Blue theme
class AppColors {
  AppColors._();

  // Primary Colors - Modern Blue Theme
  static const Color primary = Color(0xFF2196F3); // Blue 500
  static const Color primaryVariant = Color(0xFF1976D2); // Blue 700
  static const Color primaryLight = Color(0xFFBBDEFB); // Blue 100
  static const Color primaryDark = Color(0xFF0D47A1); // Blue 900

  // Background Colors - Modern Light Theme
  static const Color background = Color(0xFFFFFFFF); // Pure white
  static const Color surface = Color(0xFFF5F7FA); // Very light gray-blue
  static const Color surfaceVariant = Color(
    0xFFECEFF1,
  ); // Light gray-blue
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(
    0xFFE3F2FD,
  ); // Light blue container

  // Text Colors - Modern Theme
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on blue
  static const Color onBackground = Color(
    0xFF212121,
  ); // Dark gray for main text
  static const Color onSurface = Color(
    0xFF212121,
  ); // Dark gray for surface text
  static const Color onSurfaceVariant = Color(
    0xFF757575,
  ); // Medium gray for secondary text

  // Neutral Colors - Modern Theme
  static const Color outline = Color(0xFFBDBDBD); // Medium gray for borders
  static const Color outlineVariant = Color(
    0xFFE0E0E0,
  ); // Light gray for subtle borders

  // State Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFCE4EC);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF420000);

  static const Color warning = Color(
    0xFFFF9800,
  ); // Amber - modern warning color
  static const Color warningContainer = Color(
    0xFFFFF8E1,
  ); // Light amber container

  static const Color success = Color(0xFF388E3C);
  static const Color successContainer = Color(0xFFE8F5E9);

  // Camera Interface Colors
  static const Color cameraBackground = Color(0xFF121212); // Dark background
  static const Color cameraOverlay = Color(0x80000000);
  static const Color captureButton = Color(0xFFFFFFFF);
  static const Color captureButtonPressed = Color(0xFFE0E0E0);

  // Friend Status Colors
  static const Color friendOnline = Color(0xFF4CAF50);
  static const Color friendOffline = Color(0xFF9E9E9E);
  static const Color friendBusy = Color(0xFFF44336);

  // Widget Colors (for home screen widgets) - Modern Theme
  static const Color widgetBackground = Color(
    0xFFFFFFFF,
  ); // Pure white widget background
  static const Color widgetBorder = Color(0xFFE0E0E0); // Light gray border
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

  // Dark Theme Colors - Modern Theme
  static const Color darkBackground = Color(
    0xFF121212,
  ); // Dark background
  static const Color darkSurface = Color(
    0xFF1E1E1E,
  ); // Dark surface
  static const Color darkOnBackground = Color(0xFFFFFFFF); // White text on dark
  static const Color darkOnSurface = Color(
    0xFFFFFFFF,
  ); // White text on dark surface

  // Additional modern theme colors for comprehensive coverage
  static const Color accentBlue = Color(0xFF03DAC6); // Teal accent
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Medium gray for secondary text
  static const Color borderSubtle = Color(0xFFE0E0E0); // Light gray for subtle borders
  static const Color surfaceTinted = Color(
    0xFFE3F2FD,
  ); // Light blue for tinted surfaces
  static const Color overlayDark = Color(0x80121212); // Dark overlay
  static const Color overlayLight = Color(0x40ECEFF1); // Light overlay

  // Semi-transparent colors for overlays
  static const Color black50 = Color(0x80000000);
  static const Color black25 = Color(0x40000000);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white25 = Color(0x40FFFFFF);
}
