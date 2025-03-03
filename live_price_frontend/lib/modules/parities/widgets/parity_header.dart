import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/parities_controller.dart';

class ParityHeader extends GetView<ParitiesController> {
  const ParityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Parite Listesi', style: AppTextStyles.h2),
            ElevatedButton.icon(
              onPressed: () => controller.showAddEditDialog(),
              icon: const Icon(Icons.currency_exchange, color: Colors.white),
              label: const Text('Yeni Parite Ekle', style: TextStyle(color: Colors.white)),
              style: AppDecorations.elevatedButton,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p24),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.updateSearchQuery,
                decoration: AppDecorations.input.copyWith(
                  hintText: 'Parite ara...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<int>(
                    value: controller.selectedGroupFilter.value,
                    hint: const Text('Tüm Gruplar'),
                    items: [
                      const DropdownMenuItem(
                        value: -1,
                        child: Text('Tüm Gruplar'),
                      ),
                      ...controller.parityGroups.map(
                        (group) => DropdownMenuItem(
                          value: group.id,
                          child: Text(group.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => controller.updateGroupFilter(value ?? -1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
