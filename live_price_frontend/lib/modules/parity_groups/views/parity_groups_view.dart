import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
import '../../../core/theme/app_sizes.dart';
import '../controllers/parity_groups_controller.dart';
import '../widgets/parity_group_table.dart';
import '../widgets/parity_group_header.dart';
import '../widgets/parity_group_search_bar.dart';
import '../widgets/parity_group_pagination.dart';

class ParityGroupsView extends GetView<ParityGroupsController> {
  const ParityGroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Parite Grupları',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParityGroupHeader(controller: controller),
            const SizedBox(height: AppSizes.p16),
            ParityGroupSearchBar(controller: controller),
            const SizedBox(height: AppSizes.p16),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ParityGroupTable(
                    controller: controller,
                  ),
                ),
                const SizedBox(height: AppSizes.p16),
                ParityGroupPagination(controller: controller),
              ],
            ),
    );
  }
}
