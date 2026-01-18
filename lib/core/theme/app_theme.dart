import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'text_styles.dart';

/// Material Design 3 theme configuration for the memore clone app
/// Based on memore's brown/tan color scheme and modern Material Design principles
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      chipTheme: _chipTheme,
      floatingActionButtonTheme: _fabTheme,
      bottomNavigationBarTheme: _bottomNavTheme,
      tabBarTheme: _tabBarTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      listTileTheme: _listTileTheme,
      dividerTheme: _dividerTheme,
      iconTheme: _iconTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.surface,
      splashColor: AppColors.primary.withOpacity(0.1),
      highlightColor: AppColors.primary.withOpacity(0.05),
      focusColor: AppColors.primary.withOpacity(0.12),
    );
  }

  /// Dark theme configuration (for future implementation)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: AppColors.darkOnBackground,
        displayColor: AppColors.darkOnBackground,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkSurface,
    );
  }

  /// Light color scheme based on memore's brown/tan theme
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.primaryVariant,
    onSecondary: AppColors.onPrimary,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
  );

  /// Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkOnBackground,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
  );

  /// AppBar theme
  static AppBarTheme get _appBarTheme => const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.onBackground,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    toolbarHeight: AppSizes.appBarHeight,
    titleTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeTitle,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
      letterSpacing: AppSizes.letterSpacingNormal,
    ),
  );

  /// Elevated button theme
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: AppSizes.elevation2,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontSizeButtonLarge,
            fontWeight: FontWeight.w600,
            letterSpacing: AppSizes.letterSpacingWide,
          ),
        ),
      );

  /// Outlined button theme
  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontSizeButtonLarge,
            fontWeight: FontWeight.w600,
            letterSpacing: AppSizes.letterSpacingWide,
          ),
        ),
      );

  /// Text button theme
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: const Size(0, AppSizes.buttonHeight),
      textStyle: const TextStyle(
        fontSize: AppSizes.fontSizeButtonLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: AppSizes.letterSpacingWide,
      ),
    ),
  );

  /// Input decoration theme
  static InputDecorationTheme
  get _inputDecorationTheme => const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceContainer,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSizes.paddingMd,
      vertical: AppSizes.paddingSm,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusMd)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusMd)),
      borderSide: BorderSide(
        color: AppColors.outline,
        width: AppSizes.borderWidthThin,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusMd)),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderWidthMedium,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusMd)),
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppSizes.borderWidthThin,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusMd)),
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppSizes.borderWidthMedium,
      ),
    ),
    labelStyle: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      color: AppColors.onSurfaceVariant,
    ),
    hintStyle: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      color: AppColors.onSurfaceVariant,
    ),
  );

  /// Card theme
  static CardThemeData get _cardTheme => const CardThemeData(
    elevation: AppSizes.cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.cardBorderRadius),
      ),
    ),
    color: AppColors.surface,
    surfaceTintColor: AppColors.primary,
    margin: EdgeInsets.all(AppSizes.marginSm),
  );

  /// Chip theme
  static ChipThemeData get _chipTheme => const ChipThemeData(
    backgroundColor: AppColors.surfaceContainer,
    selectedColor: AppColors.primary,
    labelStyle: TextStyle(
      fontSize: AppSizes.fontSizeLabel,
      color: AppColors.onSurface,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.paddingSm,
      vertical: AppSizes.paddingXs,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.borderRadiusCircular),
      ),
    ),
  );

  /// Floating action button theme
  static FloatingActionButtonThemeData get _fabTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSizes.elevation3,
        shape: CircleBorder(),
      );

  /// Bottom navigation bar theme
  static BottomNavigationBarThemeData get _bottomNavTheme =>
      const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        elevation: AppSizes.elevation2,
        selectedLabelStyle: TextStyle(
          fontSize: AppSizes.fontSizeCaption,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppSizes.fontSizeCaption,
          fontWeight: FontWeight.normal,
        ),
      );

  /// Tab bar theme
  static TabBarThemeData get _tabBarTheme => const TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.onSurfaceVariant,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppSizes.borderWidthMedium,
      ),
    ),
    labelStyle: TextStyle(
      fontSize: AppSizes.fontSizeLabel,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: AppSizes.fontSizeLabel,
      fontWeight: FontWeight.normal,
    ),
  );

  /// Dialog theme
  static DialogThemeData get _dialogTheme => const DialogThemeData(
    backgroundColor: AppColors.surface,
    elevation: AppSizes.elevation4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusLg)),
    ),
    titleTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeH5,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    contentTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      color: AppColors.onSurface,
    ),
  );

  /// Snackbar theme
  static SnackBarThemeData get _snackBarTheme => const SnackBarThemeData(
    backgroundColor: AppColors.onSurface,
    contentTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      color: AppColors.surface,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusSm)),
    ),
  );

  /// List tile theme
  static ListTileThemeData get _listTileTheme => const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSizes.paddingMd,
      vertical: AppSizes.paddingSm,
    ),
    titleTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurface,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: AppSizes.fontSizeBodySmall,
      color: AppColors.onSurfaceVariant,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderRadiusSm)),
    ),
  );

  /// Divider theme
  static DividerThemeData get _dividerTheme => const DividerThemeData(
    color: AppColors.outlineVariant,
    thickness: AppSizes.borderWidthThin,
    space: AppSizes.spacingSm,
  );

  /// Icon theme
  static IconThemeData get _iconTheme => const IconThemeData(
    color: AppColors.onSurface,
    size: AppSizes.iconSizeMd,
  );
}
