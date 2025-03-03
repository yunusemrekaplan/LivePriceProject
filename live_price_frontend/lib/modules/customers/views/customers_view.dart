import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';
import 'package:live_price_frontend/modules/customers/widgets/customer_header.dart';
import 'package:live_price_frontend/modules/customers/widgets/customer_table.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Müşteriler',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomerHeader(),
            SizedBox(height: AppSizes.p24),
            CustomerTable(),
          ],
        ),
      ),
    );
  }
}
