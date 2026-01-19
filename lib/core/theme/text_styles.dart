import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Text styles based on Material Design 3 type scale
/// Configured for modern memore clone app with consistent and enhanced typography
class AppTextStyles {
  AppTextStyles._();

  /// Base text theme following Material Design 3 type scale
  static const TextTheme textTheme = TextTheme(
    // Display styles - largest text for hero elements
    displayLarge: TextStyle(
      fontSize: AppSizes.fontSizeDisplay,
      fontWeight: FontWeight.w400,
      letterSpacing: AppSizes.letterSpacingTight,
      height: AppSizes.lineHeightTight,
      color: AppColors.onBackground,
    ),
    displayMedium: TextStyle(
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: AppSizes.lineHeightTight,
      color: AppColors.onBackground,
    ),
    displaySmall: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: AppSizes.lineHeightTight,
      color: AppColors.onBackground,
    ),

    // Headline styles - for page titles and major sections
    headlineLarge: TextStyle(
      fontSize: AppSizes.fontSizeHeadline,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingTight,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onBackground,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onBackground,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onBackground,
    ),

    // Title styles - for component headers and subsections
    titleLarge: TextStyle(
      fontSize: AppSizes.fontSizeTitle,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurface,
    ),
    titleSmall: TextStyle(
      fontSize: AppSizes.fontSizeLabel,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurfaceVariant,
    ),

    // Label styles - for buttons and short text
    labelLarge: TextStyle(
      fontSize: AppSizes.fontSizeLabel,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.primary,
    ),
    labelMedium: TextStyle(
      fontSize: AppSizes.fontSizeCaption,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingExtraWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurfaceVariant,
    ),
    labelSmall: TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w600,
      letterSpacing: AppSizes.letterSpacingExtraWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurfaceVariant,
    ),

    // Body styles - for main content and reading text
    bodyLarge: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      fontWeight: FontWeight.w400,
      letterSpacing: AppSizes.letterSpacingWide,
      height: AppSizes.lineHeightRelaxed,
      color: AppColors.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: AppSizes.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: AppSizes.letterSpacingExtraWide,
      height: AppSizes.lineHeightRelaxed,
      color: AppColors.onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: AppSizes.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: AppSizes.letterSpacingExtraWide,
      height: AppSizes.lineHeightNormal,
      color: AppColors.onSurfaceVariant,
    ),
  );

  // Custom text styles for specific use cases

  /// App bar title style
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.onBackground,
  );

  /// Button text styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppSizes.fontSizeButtonLarge,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onPrimary,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppSizes.fontSizeButtonMedium,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppSizes.fontSizeButtonSmall,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onPrimary,
  );

  /// Caption styles for metadata and timestamps
  static const TextStyle caption = TextStyle(
    fontSize: AppSizes.fontSizeCaption,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: AppSizes.fontSizeCaption,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.onSurfaceVariant,
  );

  /// Error text style
  static const TextStyle error = TextStyle(
    fontSize: AppSizes.fontSizeBodyMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.error,
  );

  /// Link text style
  static const TextStyle link = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  /// Navigation text styles
  static const TextStyle bottomNavSelected = TextStyle(
    fontSize: AppSizes.fontSizeCaption,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle bottomNavUnselected = TextStyle(
    fontSize: AppSizes.fontSizeCaption,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  /// Friend list specific styles
  static const TextStyle friendName = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w500,
    letterSpacing: AppSizes.letterSpacingNormal,
    color: AppColors.onSurface,
  );

  static const TextStyle friendStatus = TextStyle(
    fontSize: AppSizes.fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle friendStatusOnline = TextStyle(
    fontSize: AppSizes.fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.friendOnline,
  );

  /// Time and date styles
  static const TextStyle timestamp = TextStyle(
    fontSize: AppSizes.fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle timestampBold = TextStyle(
    fontSize: AppSizes.fontSizeBodySmall,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingExtraWide,
    color: AppColors.onSurface,
  );

  /// Onboarding specific styles
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    letterSpacing: AppSizes.letterSpacingTight,
    height: AppSizes.lineHeightTight,
    color: AppColors.onBackground,
  );

  static const TextStyle onboardingSubtitle = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingWide,
    height: AppSizes.lineHeightRelaxed,
    color: AppColors.onSurfaceVariant,
  );

  /// Input field styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onSurface,
  );

  static const TextStyle inputHint = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.w400,
    letterSpacing: AppSizes.letterSpacingWide,
    color: AppColors.onSurfaceVariant,
  );

  /// Camera interface styles
  static const TextStyle cameraControl = TextStyle(
    fontSize: AppSizes.fontSizeBodySmall,
    fontWeight: FontWeight.w600,
    letterSpacing: AppSizes.letterSpacingWide,
    color: Colors.white,
  );

  /// Helper method to create custom text style with color override
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Helper method to create custom text style with weight override
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Helper method to create custom text style with size override
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
