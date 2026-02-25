import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';

enum AppPopupSize { small, medium, large }

class AppPopup extends StatelessWidget {
  final AppPopupSize size;
  final String? title;
  final Widget? content;
  final List<Widget>? actions;

  const AppPopup({
    super.key,
    this.size = AppPopupSize.small,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final widthRatio = size == AppPopupSize.large
        ? AppDimensions.popupLargeWidthRatio
        : AppDimensions.popupSmallWidthRatio;

    final width = screen.width * widthRatio;

    double? maxHeight;
    if (size == AppPopupSize.medium) {
      maxHeight = screen.height * AppDimensions.popupMediumMaxHeightRatio;
    } else if (size == AppPopupSize.large) {
      maxHeight = screen.height * AppDimensions.popupLargeMaxHeightRatio;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? double.infinity,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.popupBorderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.popupBorderRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.popupPadding,
                    AppDimensions.popupPadding,
                    AppDimensions.popupPadding,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title!,
                      style: GoogleFonts.inika(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
              if (content != null)
                size == AppPopupSize.small
                    ? Padding(
                        padding: const EdgeInsets.all(AppDimensions.popupPadding),
                        child: content!,
                      )
                    : Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.popupPadding),
                          child: content!,
                        ),
                      ),
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.popupPadding,
                    0,
                    AppDimensions.popupPadding,
                    AppDimensions.popupPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
