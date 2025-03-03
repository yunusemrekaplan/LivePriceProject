import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../controllers/parity_groups_controller.dart';

class ParityGroupHeader extends GetView<ParityGroupsController> {
  const ParityGroupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Parite Grupları', style: AppTextStyles.h2),
            ElevatedButton.icon(
              onPressed: () => controller.showAddEditDialog(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Yeni Grup Ekle', style: TextStyle(color: Colors.white)),
              style: AppDecorations.elevatedButton,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p24),
        TextField(
          onChanged: controller.updateSearchQuery,
          decoration: AppDecorations.input.copyWith(
            hintText: 'Grup ara...',
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
