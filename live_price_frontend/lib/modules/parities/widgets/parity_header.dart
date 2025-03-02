import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            const Text(
              'Parite Listesi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  Get.find<ParitiesController>().showAddEditDialog(),
              icon: const Icon(Icons.currency_exchange, color: Colors.white),
              label: const Text('Yeni Parite Ekle'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Parite ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<int>(
                      value: controller.selectedGroupFilter.value,
                      hint: const Text('Tüm Gruplar'),
                      items: [
                        const DropdownMenuItem(
                          value: -1,
                          child: Text('Tüm Gruplar'),
                        ),
                        ...controller.parityGroups
                            .map((group) => DropdownMenuItem(
                                  value: group.id,
                                  child: Text(group.name),
                                )),
                      ],
                      onChanged: (value) =>
                          controller.updateGroupFilter(value ?? -1),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
