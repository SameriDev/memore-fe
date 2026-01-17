/// App size constants for consistent spacing, font sizes, and dimensions
/// Based on Material Design 3 spacing system and Locket app measurements
class AppSizes {
  AppSizes._();

  // Base Spacing Unit
  static const double baseUnit = 8.0;

  // Spacing - Material Design 3 8pt grid system
  static const double spacing2xs = 2.0;  // baseUnit * 0.25
  static const double spacingXs = 4.0;   // baseUnit * 0.5
  static const double spacingSm = 8.0;   // baseUnit * 1
  static const double spacingMd = 16.0;  // baseUnit * 2
  static const double spacingLg = 24.0;  // baseUnit * 3
  static const double spacingXl = 32.0;  // baseUnit * 4
  static const double spacing2xl = 40.0; // baseUnit * 5
  static const double spacing3xl = 48.0; // baseUnit * 6

  // Padding Values
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // Margin Values
  static const double marginXs = 4.0;
  static const double marginSm = 8.0;
  static const double marginMd = 16.0;
  static const double marginLg = 24.0;
  static const double marginXl = 32.0;

  // Border Radius
  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusCircular = 999.0;

  // Component Sizes
  static const double buttonHeight = 56.0;
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightLg = 64.0;

  static const double textFieldHeight = 56.0;
  static const double textFieldBorderWidth = 2.0;

  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  // Avatar Sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;
  static const double avatar2xl = 128.0;

  // Camera & Photo Sizes
  static const double cameraButtonSize = 80.0;
  static const double cameraButtonBorder = 4.0;
  static const double photoGridItemSize = 120.0;
  static const double photoPreviewHeight = 400.0;

  // Widget Dimensions (for home screen widget)
  static const double widgetSmallWidth = 160.0;
  static const double widgetSmallHeight = 160.0;
  static const double widgetMediumWidth = 360.0;
  static const double widgetMediumHeight = 160.0;
  static const double widgetLargeWidth = 360.0;
  static const double widgetLargeHeight = 360.0;

  // Font Sizes - Material Design 3 Type Scale
  static const double fontSizeDisplay = 57.0;
  static const double fontSizeHeadline = 32.0;
  static const double fontSizeTitle = 22.0;
  static const double fontSizeLabel = 14.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeCaption = 12.0;

  // Custom Font Sizes for specific UI elements
  static const double fontSizeH1 = 32.0;
  static const double fontSizeH2 = 28.0;
  static const double fontSizeH3 = 24.0;
  static const double fontSizeH4 = 20.0;
  static const double fontSizeH5 = 18.0;
  static const double fontSizeH6 = 16.0;

  static const double fontSizeBodyLarge = 16.0;
  static const double fontSizeBodyMedium = 14.0;
  static const double fontSizeBodySmall = 12.0;

  static const double fontSizeButtonLarge = 16.0;
  static const double fontSizeButtonMedium = 14.0;
  static const double fontSizeButtonSmall = 12.0;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;

  // Letter Spacing - Material Design 3
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.15;
  static const double letterSpacingExtraWide = 0.25;

  // Border and Stroke Widths
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 4.0;

  // Elevation Values
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation3 = 3.0;
  static const double elevation4 = 4.0;
  static const double elevation5 = 5.0;

  // Screen Breakpoints
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 840.0;
  static const double breakpointDesktop = 1200.0;

  // App Bar Heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;

  // Bottom Navigation Bar
  static const double bottomNavHeight = 80.0;
  static const double bottomNavIconSize = 24.0;

  // FAB (Floating Action Button)
  static const double fabSize = 56.0;
  static const double fabSizeSmall = 40.0;
  static const double fabSizeLarge = 64.0;

  // List Item Heights
  static const double listItemHeight = 72.0;
  static const double listItemHeightSm = 56.0;
  static const double listItemHeightLg = 88.0;

  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;

  // Onboarding & Auth Screen Dimensions
  static const double logoSize = 120.0;
  static const double onboardingImageHeight = 300.0;
  static const double authFormMaxWidth = 400.0;

  // Friend List Item
  static const double friendListItemHeight = 80.0;
  static const double friendAvatarSize = 56.0;
  static const double friendStatusDotSize = 12.0;

  // Photo Grid
  static const double photoGridSpacing = 2.0;
  static const double photoGridAspectRatio = 1.0;

  // Loading Indicators
  static const double loadingIndicatorSize = 24.0;
  static const double loadingIndicatorSizeLarge = 48.0;

  // Minimum Touch Target Size (accessibility)
  static const double minTouchTargetSize = 48.0;

  // Maximum Content Width
  static const double maxContentWidth = 600.0;
}