import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../../../core/layout/admin_layout.dart';
import '../controllers/parities_controller.dart';
import '../widgets/parity_header.dart';
import '../widgets/parity_table.dart';

class ParitiesView extends GetView<ParitiesController> {
  const ParitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Pariteler',
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParityHeader(),
            SizedBox(height: AppSizes.p16),
            Expanded(
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: ParityTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
