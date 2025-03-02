import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/parities_controller.dart';
import '../models/parity_view_model.dart';

class ParityTable extends GetView<ParitiesController> {
  const ParityTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                onPressed: () =>
                    Get.find<ParitiesController>().showAddEditDialog(),
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
                  dataRowHeight: 52,
                  columns: _buildColumns(),
                  rows: controller.paginatedParities
                      .map((parity) => _buildParityRow(parity))
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      );
    });
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildSortableColumn('Adı', 'name'),
      _buildSortableColumn('Sembol', 'symbol'),
      _buildSortableColumn('API Sembol', 'apiSymbol'),
      _buildSortableColumn('Grup', 'group'),
      _buildSortableColumn('Sıra', 'orderIndex'),
      const DataColumn(
        label: Text(
          'Durum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'İşlemler',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
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
          Obx(() => GestureDetector(
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
              )),
        ],
      ),
    );
  }

  DataRow _buildParityRow(ParityViewModel parity) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            parity.name,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            parity.symbol,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            parity.apiSymbol,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            controller.getParityGroupName(parity.parityGroupId),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Text(
            parity.orderIndex.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Switch(
            value: parity.isEnabled,
            onChanged: (value) =>
                controller.toggleParityStatus(parity.id, value),
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
                onPressed: () => Get.find<ParitiesController>()
                    .showAddEditDialog(parity: parity),
                tooltip: 'Düzenle',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () =>
                    Get.find<ParitiesController>().showDeleteDialog(parity),
                tooltip: 'Sil',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: controller.currentPage.value > 0
                  ? () =>
                      controller.changePage(controller.currentPage.value - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            const SizedBox(width: 16),
            Text(
              'Sayfa ${controller.currentPage.value + 1} / ${controller.totalPages}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: controller.currentPage.value <
                      controller.totalPages - 1
                  ? () =>
                      controller.changePage(controller.currentPage.value + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ));
  }
}
