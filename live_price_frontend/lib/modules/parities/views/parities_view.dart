import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../../../core/layout/admin_layout.dart';
import '../../../core/layout/customer_layout.dart';
import '../controllers/parities_controller.dart';
import '../widgets/parity_header.dart';
import '../widgets/parity_table.dart';

class ParitiesView extends GetView<ParitiesController> {
  const ParitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();
    final userRole = tokenManager.getUserRole();
    final isCustomer = userRole == 'customer';

    final Widget pageContent = Container(
      padding: const EdgeInsets.all(AppSizes.p24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ParityHeader(),
          SizedBox(height: AppSizes.p24),
          ParityTable(),
        ],
      ),
    );

    // Kullanıcı rolüne göre uygun layout'u kullan
    if (isCustomer) {
      return CustomerLayout(
        title: 'Pariteler',
        child: pageContent,
      );
    } else {
      return AdminLayout(
        title: 'Pariteler',
        child: pageContent,
      );
    }
  }
}
