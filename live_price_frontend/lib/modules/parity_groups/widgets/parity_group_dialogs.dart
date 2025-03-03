import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import '../controllers/parity_groups_controller.dart';
import '../models/parity_group_view_model.dart';

class ParityGroupDialogs {
  static void showAddEditDialog({ParityGroupViewModel? group}) async {
    final controller = Get.find<ParityGroupsController>();
    final isEditing = group != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: group?.name ?? '');
    final descriptionController = TextEditingController(text: group?.description ?? '');
    final orderIndexController = TextEditingController(
        text: group?.orderIndex.toString() ?? controller.getNextOrderIndex().toString());
    final isEnabled = (group?.isEnabled ?? true).obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius12),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(AppSizes.p24),
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
                    isEditing ? 'Grubu Düzenle' : 'Yeni Grup Ekle',
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p24),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'İsim',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'İsim alanı zorunludur';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Açıklama',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Açıklama alanı zorunludur';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: orderIndexController,
                      decoration: InputDecoration(
                        labelText: 'Sıra',
                        prefixIcon: const Icon(Icons.format_list_numbered),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
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
                    const SizedBox(height: AppSizes.p16),
                    Obx(
                      () => SwitchListTile(
                        title: const Text('Durum'),
                        value: isEnabled.value,
                        onChanged: (value) => isEnabled.value = value,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        if (group != null) {
                          controller.updateParityGroup(
                            group.id,
                            nameController.text,
                            descriptionController.text,
                            isEnabled.value,
                            int.parse(orderIndexController.text),
                          );
                        } else {
                          controller.createParityGroup(
                            nameController.text,
                            descriptionController.text,
                            isEnabled.value,
                            int.parse(orderIndexController.text),
                          );
                        }
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isEditing ? Icons.save : Icons.add, color: Colors.white),
                        const SizedBox(width: AppSizes.p8),
                        Text(isEditing ? 'Kaydet' : 'Ekle'),
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

  static Future<void> showDeleteDialog(ParityGroupViewModel group) async {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Grubu Sil',
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
              '${group.name} grubunu silmek istediğinize emin misiniz?',
              style: const TextStyle(fontSize: AppSizes.p16, color: AppTheme.textColor),
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'Bu işlem geri alınamaz.',
              style: TextStyle(
                color: Colors.red,
                fontSize: AppSizes.p16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'İptal',
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.find<ParityGroupsController>().deleteParityGroup(group.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Sil',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
