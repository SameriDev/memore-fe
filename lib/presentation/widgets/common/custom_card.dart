import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Modern styled card component
class CustomCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final BoxShadow? shadow;

  const CustomCard({
    Key? key,
    this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.onTap,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.surface;
    final cardBorderColor = borderColor ?? Colors.transparent;
    final cardBorderRadius = borderRadius ?? AppSizes.borderRadiusMd;

    final decoration = BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(cardBorderRadius),
      border: Border.all(
        color: cardBorderColor,
        width: 1,
      ),
      boxShadow: shadow != null
          ? [shadow!]
          : [
              BoxShadow(
                color: AppColors.black25,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          decoration: decoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cardBorderRadius),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
          child: child,
        ),
      ),
    );
  }
}

/// A card with a header section
class CustomCardWithHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? headerActions;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final VoidCallback? onTap;

  const CustomCardWithHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.headerActions,
    this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: margin,
      padding: EdgeInsets.zero,
      color: color,
      borderColor: borderColor,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: BoxDecoration(
              color: color?.withOpacity(0.8) ?? AppColors.surface.withOpacity(0.8),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius ?? AppSizes.borderRadiusMd),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: AppSizes.fontSizeH6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: AppSizes.fontSizeCaption,
                          ),
                        ),
                    ],
                  ),
                ),
                if (headerActions != null) headerActions!,
              ],
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}