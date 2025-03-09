import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';

class CustomerParityGroupTable extends GetView<CustomerPanelController> {
  const CustomerParityGroupTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error.value.isNotEmpty) {
            return Center(child: Text(controller.error.value));
          }

          if (controller.filteredCustomerParityGroups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_work,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gösterilecek grup bulunamadı.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Theme(
                    data: Theme.of(Get.context!).copyWith(
                      cardColor: Colors.white,
                      dividerColor: Colors.grey[200],
                    ),
                    child: DataTable(
                      columnSpacing: 42,
                      horizontalMargin: 32,
                      headingRowHeight: 56,
                      dataRowMaxHeight: 52,
                      dataRowMinHeight: 52,
                      columns: _buildColumns(),
                      rows: _buildGroupRows(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(
        label: Text(
          'Grup Adı',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Açıklama',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Görünür',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    ];
  }

  List<DataRow> _buildGroupRows() {
    return controller.filteredCustomerParityGroups.map((group) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                const SizedBox(width: AppSizes.p8),
                Text(group.name ?? 'İsimsiz Grup',
                    style: AppTextStyles.tableCell),
              ],
            ),
          ),
          DataCell(
              Text(group.description ?? '-', style: AppTextStyles.tableCell)),
          DataCell(
            Switch(
              value: group.isVisible,
              onChanged: (value) =>
                  controller.toggleParityGroupVisibility(group.id, value),
              activeColor: AppColors.switchActive,
              inactiveTrackColor: AppColors.switchInactive,
            ),
          ),
        ],
      );
    }).toList();
  }
}
