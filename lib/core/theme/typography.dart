import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Extended typography definitions for the memore app
/// Provides consistent text styles across the application
class AppTypography {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 96.0,
    fontWeight: FontWeight.w300,
    color: AppColors.onBackground,
    letterSpacing: -1.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 60.0,
    fontWeight: FontWeight.w300,
    color: AppColors.onBackground,
    letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.0,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.25,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.0,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    letterSpacing: 0.15,
  );

  // Subheadings
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.15,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    letterSpacing: 0.1,
  );

  // Body text
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.25,
  );

  // Buttons and captions
  static const TextStyle button = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    letterSpacing: 1.25,
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 0.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
    letterSpacing: 1.5,
    textBaseline: TextBaseline.alphabetic,
  );

  // Custom styles for specific use cases
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground,
    letterSpacing: 0.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    letterSpacing: 0.15,
  );

  static const TextStyle listItemTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static const TextStyle listItemSubtitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onPrimary,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );
}