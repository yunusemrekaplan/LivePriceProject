import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParityGroupHeader(controller: controller),
            const SizedBox(height: 16),
            ParityGroupSearchBar(controller: controller),
            const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ParityGroupPagination(controller: controller),
              ],
            ),
    );
  }
}
