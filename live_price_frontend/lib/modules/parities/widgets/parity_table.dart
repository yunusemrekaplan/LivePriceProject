import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import 'package:live_price_frontend/modules/parities/controllers/parities_controller.dart';

class ParityTable extends GetView<ParitiesController> {
  const ParityTable({super.key});

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

          if (controller.parities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz parite eklenmemiş',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => controller.showAddEditDialog(),
                    child: const Text('Parite Ekle'),
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
                      rows: _buildParityRows(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPagination(),
            ],
          );
        }),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildSortableColumn('Adı', 'name'),
      _buildSortableColumn('Sembol', 'symbol'),
      _buildSortableColumn('API Sembol', 'apiSymbol'),
      _buildSortableColumn('Grup', 'group'),
      _buildSortableColumn('Sıra', 'orderIndex'),
      _buildSortableColumn('Ondalık', 'scale'),
      //_buildSortableColumn('Spread Tipi', 'spreadRuleType'),
      //_buildSortableColumn('Alış Spread', 'spreadForAsk'),
      //_buildSortableColumn('Satış Spread', 'spreadForBid'),
      const DataColumn(
        label: Text(
          'Spread Tipi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      const DataColumn(
        label: Text(
          'Alış Spread',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      const DataColumn(
        label: Text(
          'Satış Spread',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      const DataColumn(
        label: Text(
          'Durum',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      const DataColumn(
        label: Text(
          'İşlemler',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    ];
  }

  DataColumn _buildSortableColumn(String label, String field) {
    return DataColumn(
      label: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
          Obx(
            () => GestureDetector(
              onTap: () => controller.changeSort(field),
              child: Icon(
                controller.sortField.value == field
                    ? (controller.sortAscending.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color: controller.sortField.value == field
                    ? AppTheme.primaryColor
                    : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildParityRows() {
    return controller.paginatedParities.map((parity) {
      return DataRow(
        cells: [
          DataCell(Text(parity.name, style: AppTextStyles.tableCell)),
          DataCell(Text(parity.symbol, style: AppTextStyles.tableCell)),
          DataCell(Text(parity.rawSymbol, style: AppTextStyles.tableCell)),
          DataCell(
            Text(controller.getParityGroupName(parity.parityGroupId),
                style: AppTextStyles.tableCell),
          ),
          DataCell(Text(parity.orderIndex.toString(),
              style: AppTextStyles.tableCell)),
          DataCell(
              Text(parity.scale.toString(), style: AppTextStyles.tableCell)),
          DataCell(Text(parity.spreadRuleType?.name ?? "",
              style: AppTextStyles.tableCell)),
          DataCell(Text(parity.spreadForAsk.toString(),
              style: AppTextStyles.tableCell)),
          DataCell(Text(parity.spreadForBid.toString(),
              style: AppTextStyles.tableCell)),
          DataCell(
            Switch(
              value: parity.isEnabled,
              onChanged: (value) =>
                  controller.toggleParityStatus(parity.id, value),
              activeColor: AppColors.switchActive,
              inactiveTrackColor: AppColors.switchInactive,
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () => controller.showAddEditDialog(parity: parity),
                  tooltip: 'Düzenle',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.error,
                  ),
                  onPressed: () => controller.showDeleteDialog(parity),
                  tooltip: 'Sil',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildPagination() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: controller.currentPage.value > 0
                ? () => controller.changePage(controller.currentPage.value - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          Text(
            'Sayfa ${controller.currentPage.value + 1} / ${controller.totalPages}',
            style: AppTextStyles.body1,
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: controller.currentPage.value < controller.totalPages - 1
                ? () => controller.changePage(controller.currentPage.value + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: controller.currentPage.value < controller.totalPages - 1
                ? AppColors.primaryColor
                : AppColors.disabledButton,
          ),
        ],
      ),
    );
  }
}
