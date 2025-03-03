import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/parities_controller.dart';
import '../models/parity_view_model.dart';

class ParityDialogs {
  static void showAddEditDialog({ParityViewModel? parity}) {
    final controller = Get.find<ParitiesController>();
    final isEditing = parity != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: parity?.name);
    final symbolController = TextEditingController(text: parity?.symbol);
    final apiSymbolController = TextEditingController(text: parity?.apiSymbol);
    final orderIndexController = TextEditingController(text: parity?.orderIndex.toString());
    final isEnabled = (parity?.isEnabled ?? true).obs;

    // Initialize selectedGroupId with the default selected group
    controller.selectedGroupId.value = parity?.parityGroupId;

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
                    isEditing ? 'Parite Düzenle' : 'Yeni Parite Ekle',
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
                        labelText: 'Parite Adı',
                        hintText: 'Örn: Gram Altın',
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: symbolController,
                      decoration: InputDecoration(
                        labelText: 'Sembol',
                        hintText: 'Örn: XAU/TRY',
                        prefixIcon: const Icon(Icons.currency_exchange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: apiSymbolController,
                      decoration: InputDecoration(
                        labelText: 'API Sembol',
                        hintText: 'Örn: XAUUSD',
                        prefixIcon: const Icon(Icons.api),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) => value?.isEmpty == true ? 'Bu alan zorunludur' : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    DropdownButtonFormField<int>(
                      value: parity?.parityGroupId,
                      decoration: InputDecoration(
                        labelText: 'Parite Grubu',
                        hintText: 'Grup seçin',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      items: controller.parityGroups
                          .map(
                            (group) => DropdownMenuItem(
                              value: group.id,
                              child: Text(group.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null && !isEditing) {
                          orderIndexController.text =
                              controller.getNextOrderIndexForGroup(value).toString();
                        }
                        controller.selectedGroupId.value = value;
                      },
                      validator: (value) => value == null ? 'Lütfen bir grup seçin' : null,
                      onSaved: (value) {
                        if (value != null) {
                          controller.selectedGroupId.value = value;
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: orderIndexController,
                      decoration: InputDecoration(
                        labelText: 'Sıra',
                        hintText: 'Örn: 1',
                        prefixIcon: const Icon(Icons.sort),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
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
                    const SizedBox(height: AppSizes.p16),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.p16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(AppSizes.radius8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.toggle_on,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Durum',
                                style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => Switch(
                              value: isEnabled.value,
                              onChanged: (value) => isEnabled.value = value,
                              activeColor: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p24),
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
                        if (controller.selectedGroupId.value != null) {
                          if (isEditing) {
                            controller.updateParity(
                              parity.id,
                              nameController.text,
                              symbolController.text,
                              apiSymbolController.text,
                              isEnabled.value,
                              int.parse(orderIndexController.text),
                              controller.selectedGroupId.value!,
                            );
                          } else {
                            controller.createParity(
                              nameController.text,
                              symbolController.text,
                              apiSymbolController.text,
                              isEnabled.value,
                              int.parse(orderIndexController.text),
                              controller.selectedGroupId.value!,
                            );
                          }
                          Get.back();
                        } else {
                          Get.snackbar('Hata', 'Lütfen bir grup seçin');
                        }
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

  static void showDeleteDialog(ParityViewModel parity) {
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
              Get.find<ParitiesController>().deleteParity(parity.id);
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
