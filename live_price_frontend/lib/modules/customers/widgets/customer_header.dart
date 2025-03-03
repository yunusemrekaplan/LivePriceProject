import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';

class CustomerHeader extends GetView<CustomersController> {
  const CustomerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Müşteriler', style: AppTextStyles.h2),
            ElevatedButton.icon(
              onPressed: () => controller.showAddEditDialog(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Yeni Müşteri', style: TextStyle(color: Colors.white)),
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
