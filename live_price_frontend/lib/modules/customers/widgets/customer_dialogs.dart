import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';
import 'package:live_price_frontend/modules/customers/models/customer_view_model.dart';

class CustomerDialogs {
  static void showAddEditDialog({CustomerViewModel? customer}) async {
    final controller = Get.find<CustomersController>();
    final isEditing = customer != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: customer?.name);

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
                    isEditing ? 'Müşteri Düzenle' : 'Yeni Müşteri Ekle',
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
                        labelText: 'Müşteri Adı',
                        hintText: 'Müşteri adını giriniz',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Müşteri adı boş olamaz';
                        }
                        return null;
                      },
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
                      if (formKey.currentState!.validate()) {
                        if (isEditing) {
                          controller.updateCustomer(
                            customer.id,
                            nameController.text,
                          );
                        } else {
                          controller.createCustomer(
                            nameController.text,
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

    /*Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Müşteri Düzenle' : 'Yeni Müşteri Ekle'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Müşteri Adı',
                  hintText: 'Müşteri adını giriniz',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Müşteri adı boş olamaz';
                  }
                  return null;
                },
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
              if (formKey.currentState!.validate()) {
                if (isEditing) {
                  controller.updateCustomer(
                    customer.id,
                    nameController.text,
                  );
                } else {
                  controller.createCustomer(
                    nameController.text,
                  );
                }
                Get.back();
              }
            },
            child: Text(isEditing ? 'Güncelle' : 'Ekle'),
          ),
        ],
      ),
    );*/
  }

  static void showDeleteDialog(CustomerViewModel customer) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Müşteri Sil',
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
              '${customer.name} adlı müşteriyi silmek istediğinize emin misiniz?',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.find<CustomersController>().deleteCustomer(customer.id);
              Get.back();
            },
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
