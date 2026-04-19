import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FlushbarUtils {
  //SUCCESS ALERT
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(
      context,
      message: message,
      title: title,
      icon: Icons.check_circle_outline,
      color: Colors.green.shade600,
    );
  }

  //ERROR ALERT
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(
      context,
      message: message,
      title: title,
      icon: Icons.error_outline,
      color: AppColors.errorRed,
    );
  }

  //ERROR ALERT
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(
      context,
      message: message,
      title: title,
      icon: Icons.warning,
      color: AppColors.warningAction,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    String? title,
    required IconData icon,
    required Color color,
  }) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(icon, size: 28.0, color: Colors.white),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: color,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: const [
        BoxShadow(color: Colors.black45, offset: Offset(0, 3), blurRadius: 6),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastOutSlowIn,
    ).show(context);
  }
}
