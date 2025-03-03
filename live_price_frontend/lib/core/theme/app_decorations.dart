import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppDecorations {
  // Card dekorasyonları
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration cardHover = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  // Input dekorasyonları
  static InputDecoration input = InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
      borderSide: const BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
      borderSide: const BorderSide(color: AppColors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
      borderSide: const BorderSide(color: AppColors.inputFocused),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
      borderSide: const BorderSide(color: AppColors.inputError),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSizes.p16,
      vertical: AppSizes.p12,
    ),
  );

  // Button dekorasyonları
  static ButtonStyle elevatedButton = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24, vertical: AppSizes.p16),
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.buttonText,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
    ),
  );

  static ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primaryColor,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.p16,
      vertical: AppSizes.p12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
    ),
    side: const BorderSide(color: AppColors.primaryColor),
  );

  // Table dekorasyonları
  static BoxDecoration tableHeader = const BoxDecoration(
    color: AppColors.tableHeader,
    border: Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  static BoxDecoration tableRow = const BoxDecoration(
    border: Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  static BoxDecoration tableRowHover = const BoxDecoration(
    color: AppColors.tableRowHover,
    border: Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  static BoxDecoration tableRowSelected = const BoxDecoration(
    color: AppColors.tableRowSelected,
    border: Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  // Dialog dekorasyonları
  static BoxDecoration dialog = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSizes.radius12),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
  );
}
