import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppTextStyles {
  // Başlık stilleri
  static const TextStyle h1 = TextStyle(
    fontSize: AppSizes.text32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: AppSizes.text28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: AppSizes.text24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: AppSizes.text20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Gövde metin stilleri
  static const TextStyle body1 = TextStyle(
    fontSize: AppSizes.text16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Alt başlık stilleri
  static const TextStyle subtitle1 = TextStyle(
    fontSize: AppSizes.text16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Buton metin stilleri
  static const TextStyle button = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.w500,
    color: AppColors.buttonText,
    letterSpacing: 0.5,
  );

  // Tablo metin stilleri
  static const TextStyle tableHeader = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle tableCell = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Form metin stilleri
  static const TextStyle label = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: AppSizes.text14,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  static const TextStyle error = TextStyle(
    fontSize: AppSizes.text12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );
}
