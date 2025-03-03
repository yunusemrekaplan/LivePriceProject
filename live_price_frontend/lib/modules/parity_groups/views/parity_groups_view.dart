import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/layout/admin_layout.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../controllers/parity_groups_controller.dart';
import '../widgets/parity_group_header.dart';
import '../widgets/parity_group_table.dart';

class ParityGroupsView extends GetView<ParityGroupsController> {
  const ParityGroupsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Parite Grupları',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParityGroupHeader(),
            SizedBox(height: AppSizes.p24),
            ParityGroupTable(),
          ],
        ),
      ),
    );
  }
}
