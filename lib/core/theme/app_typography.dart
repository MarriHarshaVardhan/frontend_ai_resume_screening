import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const TextStyle heroTitleAccent = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.badgeText,
  );

  static const TextStyle stepNumber = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle ctaTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle ctaSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE2DBFF),
    height: 1.5,
  );

  static const TextStyle navLink = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );
}
