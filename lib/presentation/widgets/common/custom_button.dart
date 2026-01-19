import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Modern styled button component
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style,
    this.textStyle,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = style ??
        ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.onPrimary,
          minimumSize: Size(width ?? double.infinity, height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
          elevation: 0,
        );

    Widget child = Text(
      text,
      style: textStyle ??
          const TextStyle(
            fontSize: AppSizes.fontSizeButtonLarge,
            fontWeight: FontWeight.w600,
          ),
    );

    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor ?? AppColors.onPrimary),
          const SizedBox(width: AppSizes.spacingSm),
          Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: AppSizes.fontSizeButtonLarge,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

/// Outline button variant
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomOutlineButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.icon,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: 1.5,
          ),
          foregroundColor: textColor ?? AppColors.primary,
          minimumSize: Size(width ?? double.infinity, height ?? 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: textColor ?? AppColors.primary),
                  const SizedBox(width: AppSizes.spacingSm),
                  Text(
                    text,
                    style: textStyle ??
                        TextStyle(
                          color: textColor ?? AppColors.primary,
                          fontSize: AppSizes.fontSizeButtonLarge,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              )
            : Text(
                text,
                style: textStyle ??
                    TextStyle(
                      color: textColor ?? AppColors.primary,
                      fontSize: AppSizes.fontSizeButtonLarge,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}

/// Text button variant
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? textColor;

  const CustomTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: textColor ?? AppColors.primary,
              fontSize: AppSizes.fontSizeButtonLarge,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}