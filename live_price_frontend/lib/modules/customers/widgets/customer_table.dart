import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';

class CustomerTable extends GetView<CustomersController> {
  const CustomerTable({super.key});

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

          if (controller.customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz müşteri eklenmemiş',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => controller.showAddEditDialog(),
                    child: const Text('Müşteri Ekle'),
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
                      columns: _buildColumns(),
                      rows: _buildRows(),
                      columnSpacing: 42,
                      horizontalMargin: 32,
                      headingRowHeight: 56,
                      dataRowMaxHeight: 52,
                      dataRowMinHeight: 52,
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
      _buildSortableColumn('ID', 'id'),
      _buildSortableColumn('Müşteri Adı', 'name'),
      _buildSortableColumn('Oluşturulma Tarihi', 'createdAt'),
      const DataColumn(
        label: Text(
          'İşlemler',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.p16),
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
                    ? (controller.sortAscending.value ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color:
                    controller.sortField.value == field ? AppColors.primaryColor : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildRows() {
    return controller.paginatedCustomers.map((customer) {
      return DataRow(
        cells: [
          DataCell(Text(customer.id.toString(), style: AppTextStyles.tableCell)),
          DataCell(Text(customer.name, style: AppTextStyles.tableCell)),
          customer.createdAt != null
              ? DataCell(
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(customer.createdAt!),
                    style: AppTextStyles.tableCell,
                  ),
                )
              : const DataCell(Text('')),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  ),
                  tooltip: 'Düzenle',
                  onPressed: () => controller.showAddEditDialog(customer: customer),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.error,
                  ),
                  tooltip: 'Sil',
                  onPressed: () => controller.deleteCustomer(customer.id),
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
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.currentPage.value > 0
                ? () => controller.changePage(controller.currentPage.value - 1)
                : null,
            color: controller.currentPage.value > 0
                ? AppColors.primaryColor
                : AppColors.disabledButton,
          ),
          const SizedBox(width: 16),
          Text(
            'Sayfa ${controller.currentPage.value + 1} / ${controller.totalPages}',
            style: AppTextStyles.body1,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.currentPage.value < controller.totalPages - 1
                ? () => controller.changePage(controller.currentPage.value + 1)
                : null,
            color: controller.currentPage.value < controller.totalPages - 1
                ? AppColors.primaryColor
                : AppColors.disabledButton,
          ),
        ],
      ),
    );
  }
}
