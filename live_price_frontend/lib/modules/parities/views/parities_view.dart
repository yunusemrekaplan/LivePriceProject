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
    return Row(
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
          icon: const Icon(Icons.add),
          label: const Text('Yeni Parite Ekle'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
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

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Theme(
            data: Theme.of(Get.context!).copyWith(
              cardColor: Colors.white,
              dividerColor: Colors.grey[200],
            ),
            child: DataTable(
              columnSpacing: 24,
              horizontalMargin: 24,
              headingRowHeight: 56,
              dataRowHeight: 52,
              columns: const [
                DataColumn(
                  label: Text(
                    'Adı',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sembol',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Grup',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sıra',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Durum',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'İşlemler',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: controller.parities
                  .map((parity) => _buildParityRow(parity))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }

  DataRow _buildParityRow(ParityViewModel parity) {
    return DataRow(
      cells: [
        DataCell(Text(parity.name)),
        DataCell(Text(parity.symbol)),
        DataCell(Text(controller.getParityGroupName(parity.parityGroupId))),
        DataCell(Text(parity.orderIndex.toString())),
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
    var isEnabled = parity?.isEnabled ?? true;

    Get.dialog(
      AlertDialog(
        title: Text(
          isEditing ? 'Parite Düzenle' : 'Yeni Parite Ekle',
          style: const TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Parite Adı',
                    hintText: 'Örn: Gram Altın',
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Sembol',
                    hintText: 'Örn: XAU/TRY',
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: parity?.parityGroupId,
                  decoration: const InputDecoration(
                    labelText: 'Parite Grubu',
                    hintText: 'Grup seçin',
                  ),
                  items: controller.parityGroups
                      .map((group) => DropdownMenuItem(
                            value: group.id,
                            child: Text(group.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      controller.selectedGroupId.value = value,
                  validator: (value) =>
                      value == null ? 'Lütfen bir grup seçin' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: orderIndexController,
                  decoration: const InputDecoration(
                    labelText: 'Sıra',
                    hintText: 'Örn: 1',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Durum',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                      value: isEnabled,
                      onChanged: (value) => isEnabled = value,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                if (isEditing) {
                  controller.updateParity(
                    parity.id,
                    nameController.text,
                    symbolController.text,
                    isEnabled,
                    int.parse(orderIndexController.text),
                    controller.selectedGroupId.value!,
                  );
                } else {
                  controller.createParity(
                    nameController.text,
                    symbolController.text,
                    isEnabled,
                    int.parse(orderIndexController.text),
                    controller.selectedGroupId.value!,
                  );
                }
                Get.back();
              }
            },
            child: Text(isEditing ? 'Güncelle' : 'Ekle'),
          ),
        ],
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
