import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';

class CustomerParityGroupHeader extends GetView<CustomerPanelController> {
  const CustomerParityGroupHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Döviz Kuru Grupları', style: AppTextStyles.h2),
          ],
        ),
        const SizedBox(height: AppSizes.p24),
        TextField(
          onChanged: controller.searchCustomerParityGroups,
          decoration: AppDecorations.input.copyWith(
            hintText: 'Grup ara...',
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
