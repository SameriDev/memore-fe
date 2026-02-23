import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/theme/app_colors.dart';

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error, Icons.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.primary, Icons.info);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, AppColors.warning, Icons.warning);
  }

  static void _show(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inika(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
