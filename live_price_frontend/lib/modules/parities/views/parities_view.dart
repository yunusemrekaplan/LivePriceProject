import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/layout/admin_layout.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/parities_controller.dart';
import '../models/parity_view_model.dart';

class ParitiesView extends GetView<ParitiesController> {
  const ParitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Pariteler',
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: _buildParitiesTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Parite Listesi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddEditDialog(),
              icon: const Icon(Icons.currency_exchange, color: Colors.white),
              label: Text('Yeni Parite Ekle'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Parite ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<int>(
                      value: controller.selectedGroupFilter.value,
                      hint: const Text('Tüm Gruplar'),
                      items: [
                        const DropdownMenuItem(
                          value: -1,
                          child: Text('Tüm Gruplar'),
                        ),
                        ...controller.parityGroups
                            .map((group) => DropdownMenuItem(
                                  value: group.id,
                                  child: Text(group.name),
                                )),
                      ],
                      onChanged: (value) =>
                          controller.updateGroupFilter(value ?? -1),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParitiesTable() {
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
                onPressed: () => _showAddEditDialog(),
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
                  columns: [
                    DataColumn(
                      label: Row(
                        children: [
                          const Text(
                            'Adı',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Obx(() => GestureDetector(
                                onTap: () => controller.changeSort('name'),
                                child: Icon(
                                  controller.sortField.value == 'name'
                                      ? (controller.sortAscending.value
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward)
                                      : Icons.unfold_more,
                                  size: 16,
                                  color: controller.sortField.value == 'name'
                                      ? AppTheme.primaryColor
                                      : Colors.grey[400],
                                ),
                              )),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          const Text(
                            'Sembol',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Obx(() => GestureDetector(
                                onTap: () => controller.changeSort('symbol'),
                                child: Icon(
                                  controller.sortField.value == 'symbol'
                                      ? (controller.sortAscending.value
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward)
                                      : Icons.unfold_more,
                                  size: 16,
                                  color: controller.sortField.value == 'symbol'
                                      ? AppTheme.primaryColor
                                      : Colors.grey[400],
                                ),
                              )),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Grup',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          const Text(
                            'Sıra',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Obx(() => GestureDetector(
                                onTap: () =>
                                    controller.changeSort('orderIndex'),
                                child: Icon(
                                  controller.sortField.value == 'orderIndex'
                                      ? (controller.sortAscending.value
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward)
                                      : Icons.unfold_more,
                                  size: 16,
                                  color:
                                      controller.sortField.value == 'orderIndex'
                                          ? AppTheme.primaryColor
                                          : Colors.grey[400],
                                ),
                              )),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Durum',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'İşlemler',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
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
                onPressed: () => _showAddEditDialog(parity: parity),
                tooltip: 'Düzenle',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => _showDeleteDialog(parity),
                tooltip: 'Sil',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddEditDialog({ParityViewModel? parity}) {
    final isEditing = parity != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: parity?.name);
    final symbolController = TextEditingController(text: parity?.symbol);
    final orderIndexController = TextEditingController(
      text: parity?.orderIndex.toString(),
    );
    final isEnabled = (parity?.isEnabled ?? true).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add_circle,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Parite Düzenle' : 'Yeni Parite Ekle',
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Parite Adı',
                        hintText: 'Örn: Gram Altın',
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: symbolController,
                      decoration: InputDecoration(
                        labelText: 'Sembol',
                        hintText: 'Örn: XAU/TRY',
                        prefixIcon: const Icon(Icons.currency_exchange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) =>
                          value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: parity?.parityGroupId,
                      decoration: InputDecoration(
                        labelText: 'Parite Grubu',
                        hintText: 'Grup seçin',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: controller.parityGroups
                          .map((group) => DropdownMenuItem(
                                value: group.id,
                                child: Text(group.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null && !isEditing) {
                          orderIndexController.text = controller
                              .getNextOrderIndexForGroup(value)
                              .toString();
                        }
                        controller.selectedGroupId.value = value;
                      },
                      validator: (value) =>
                          value == null ? 'Lütfen bir grup seçin' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: orderIndexController,
                      decoration: InputDecoration(
                        labelText: 'Sıra',
                        hintText: 'Örn: 1',
                        prefixIcon: const Icon(Icons.sort),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Bu alan zorunludur';
                        if (int.tryParse(value!) == null) {
                          return 'Geçerli bir sayı girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.toggle_on,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Durum',
                                style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Obx(() => Switch(
                                value: isEnabled.value,
                                onChanged: (value) => isEnabled.value = value,
                                activeColor: AppTheme.primaryColor,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        if (isEditing) {
                          controller.updateParity(
                            parity.id,
                            nameController.text,
                            symbolController.text,
                            isEnabled.value,
                            int.parse(orderIndexController.text),
                            controller.selectedGroupId.value!,
                          );
                        } else {
                          controller.createParity(
                            nameController.text,
                            symbolController.text,
                            isEnabled.value,
                            int.parse(orderIndexController.text),
                            controller.selectedGroupId.value!,
                          );
                        }
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isEditing ? Icons.save : Icons.add,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(isEditing ? 'Güncelle' : 'Ekle'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(ParityViewModel parity) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Pariteyi Sil',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${parity.name} paritesini silmek istediğinize emin misiniz?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bu işlem geri alınamaz.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteParity(parity.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
