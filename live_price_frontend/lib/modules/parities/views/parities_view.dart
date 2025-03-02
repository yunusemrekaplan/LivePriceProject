import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/layout/admin_layout.dart';
import '../controllers/parities_controller.dart';
import '../models/parity_view_model.dart';

class ParitiesView extends GetView<ParitiesController> {
  const ParitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Pariteler',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildParitiesTable(),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddEditDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Yeni Parite Ekle'),
        ),
      ],
    );
  }

  Widget _buildParitiesTable() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Adı')),
                DataColumn(label: Text('Sembol')),
                DataColumn(label: Text('Grup')),
                DataColumn(label: Text('Sıra')),
                DataColumn(label: Text('Durum')),
                DataColumn(label: Text('İşlemler')),
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
                icon: const Icon(Icons.edit),
                onPressed: () => _showAddEditDialog(parity: parity),
                tooltip: 'Düzenle',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
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
        title: Text(isEditing ? 'Parite Düzenle' : 'Yeni Parite Ekle'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Parite Adı'),
                validator: (value) =>
                value?.isEmpty == true ? 'Bu alan zorunludur' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: symbolController,
                decoration: const InputDecoration(labelText: 'Sembol'),
                validator: (value) =>
                value?.isEmpty == true ? 'Bu alan zorunludur' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: parity?.parityGroupId,
                decoration: const InputDecoration(labelText: 'Parite Grubu'),
                items: controller.parityGroups
                    .map((group) => DropdownMenuItem(
                  value: group.id,
                  child: Text(group.name),
                ))
                    .toList(),
                onChanged: (value) => controller.selectedGroupId.value = value,
                validator: (value) =>
                value == null ? 'Lütfen bir grup seçin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: orderIndexController,
                decoration: const InputDecoration(labelText: 'Sıra'),
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
                  const Text('Durum'),
                  Switch(
                    value: isEnabled,
                    onChanged: (value) => isEnabled = value,
                  ),
                ],
              ),
            ],
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
        title: const Text('Pariteyi Sil'),
        content:
            Text('${parity.name} paritesini silmek istediğinize emin misiniz?'),
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
