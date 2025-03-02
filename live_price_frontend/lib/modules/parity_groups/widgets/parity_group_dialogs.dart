import 'package:flutter/material.dart';
import '../controllers/parity_groups_controller.dart';
import '../models/parity_group_view_model.dart';

class ParityGroupDialogs {
  static Future<void> showAddEditDialog({
    required BuildContext context,
    required ParityGroupsController controller,
    ParityGroupViewModel? group,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: group?.name ?? '');
    final descriptionController =
        TextEditingController(text: group?.description ?? '');
    final orderIndexController = TextEditingController(
        text: group?.orderIndex.toString() ??
            controller.getNextOrderIndex().toString());
    final isEnabled = group?.isEnabled ?? true;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group == null ? 'Yeni Grup Ekle' : 'Grubu Düzenle'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İsim alanı zorunludur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Açıklama alanı zorunludur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: orderIndexController,
                decoration: const InputDecoration(labelText: 'Sıra'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sıra alanı zorunludur';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Geçerli bir sayı giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) {
                  return SwitchListTile(
                    title: const Text('Durum'),
                    value: isEnabled,
                    onChanged: (value) => setState(() => isEnabled == value),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (group != null) {
                  controller.updateParityGroup(
                    group.id,
                    nameController.text,
                    descriptionController.text,
                    isEnabled,
                    int.parse(orderIndexController.text),
                  );
                } else {
                  controller.createParityGroup(
                    nameController.text,
                    descriptionController.text,
                    isEnabled,
                    int.parse(orderIndexController.text),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(group == null ? 'Ekle' : 'Güncelle'),
          ),
        ],
      ),
    );
  }

  static Future<void> showDeleteDialog({
    required BuildContext context,
    required ParityGroupsController controller,
    required ParityGroupViewModel group,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grubu Sil'),
        content:
            Text('${group.name} grubunu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteParityGroup(group.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
