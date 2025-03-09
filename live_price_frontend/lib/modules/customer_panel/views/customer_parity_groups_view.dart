import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/customer_layout.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';
import 'package:live_price_frontend/modules/customer_panel/widgets/customer_parity_group_header.dart';
import 'package:live_price_frontend/modules/customer_panel/widgets/customer_parity_group_table.dart';

class CustomerParityGroupsView extends GetView<CustomerPanelController> {
  const CustomerParityGroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomerLayout(
      title: 'Parite Grupları',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomerParityGroupHeader(),
            SizedBox(height: AppSizes.p24),
            CustomerParityGroupTable(),
          ],
        ),
      ),
    );
  }
}
