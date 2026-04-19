import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Brand Header
  static const TextStyle brandLogoName = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.greyTextPrimary,
    fontFamily: 'SFProDisplay',
  );

  // Sign In Header
  static const TextStyle headerPrimary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.greyTextPrimary,
  );

  // Sign In Header
  static const TextStyle headerTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.greyTextPrimary,
  );

  // Sub-header (Hi! Good to see you...)
  static const TextStyle bodyTextSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.greyTextSecondary,
    height: 1.4,
  );
  static const TextStyle bodyTextTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Text field Labels (Email *, Password *)
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.greyTextPrimary,
  );

  // "Remember Me" and Social Text
  static const TextStyle bodyTextPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.greyTextPrimary,
  );

  // Purple Links (Forgot Password, Sign In with...)
  static const TextStyle linkTextPurple = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // Blue Link (Contact)
  static const TextStyle linkTextBlue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.actionBlue,
  );
}
