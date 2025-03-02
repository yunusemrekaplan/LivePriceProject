import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppDecorations {
  // Card dekorasyonları
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration cardHover = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 8,
        offset: const Offset(0, 4),
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
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.buttonText,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.p16,
      vertical: AppSizes.p12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
    ),
  );

  static ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.p16,
      vertical: AppSizes.p12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius8),
    ),
    side: const BorderSide(color: AppColors.primary),
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

  static BoxDecoration tableRowHover = BoxDecoration(
    color: AppColors.tableRowHover,
    border: const Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  static BoxDecoration tableRowSelected = BoxDecoration(
    color: AppColors.tableRowSelected,
    border: const Border(
      bottom: BorderSide(color: AppColors.tableBorder),
    ),
  );

  // Dialog dekorasyonları
  static BoxDecoration dialog = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSizes.radius12),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
