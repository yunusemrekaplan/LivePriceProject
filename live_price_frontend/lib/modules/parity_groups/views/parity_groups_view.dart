import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
import 'package:live_price_frontend/core/layout/customer_layout.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../controllers/parity_groups_controller.dart';
import '../widgets/parity_group_header.dart';
import '../widgets/parity_group_table.dart';

class ParityGroupsView extends GetView<ParityGroupsController> {
  const ParityGroupsView({super.key});

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
          ParityGroupHeader(),
          SizedBox(height: AppSizes.p24),
          ParityGroupTable(),
        ],
      ),
    );

    // Kullanıcı rolüne göre uygun layout'u kullan
    if (isCustomer) {
      return CustomerLayout(
        title: 'Parite Grupları',
        child: pageContent,
      );
    } else {
      return AdminLayout(
        title: 'Parite Grupları',
        child: pageContent,
      );
    }
  }
}
