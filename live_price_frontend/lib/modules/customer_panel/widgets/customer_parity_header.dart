import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';

class CustomerParityHeader extends GetView<CustomerPanelController> {
  const CustomerParityHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Döviz Kurları', style: AppTextStyles.h2),
          ],
        ),
        const SizedBox(height: AppSizes.p24),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.searchCustomerParities,
                decoration: AppDecorations.input.copyWith(
                  hintText: 'Döviz kuru ara...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p16),
            _buildGroupFilter(),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupFilter() {
    return Obx(() {
      if (controller.customerParityGroups.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedParityGroup.value == 0
                ? 0
                : controller.selectedParityGroup.value,
            hint: const Text('Tüm Gruplar'),
            items: [
              const DropdownMenuItem(
                value: 0,
                child: Text('Tüm Gruplar'),
              ),
              ...controller.customerParityGroups.map(
                (group) => DropdownMenuItem(
                  value: group.id,
                  child: Text(group.name ?? 'Bilinmeyen Grup'),
                ),
              ),
            ],
            onChanged: (value) => controller.filterParitiesByGroup(value ?? 0),
          ),
        ),
      );
    });
  }
}
