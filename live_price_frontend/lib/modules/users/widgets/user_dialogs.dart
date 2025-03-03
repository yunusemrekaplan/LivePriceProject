import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/modules/customers/models/customer_view_model.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';
import 'package:live_price_frontend/modules/users/models/user_role.dart';
import 'package:live_price_frontend/modules/users/models/user_view_model.dart';

class UserDialogs {
  static void showAddEditDialog({
    UserViewModel? user,
    required List<CustomerViewModel> customers,
  }) {
    final controller = Get.find<UsersController>();
    final isEditing = user != null;
    final formKey = GlobalKey<FormState>();

    final usernameController = TextEditingController(text: user?.username);
    final passwordController = TextEditingController();
    final emailController = TextEditingController(text: user?.email);
    final nameController = TextEditingController(text: user?.name);
    final surnameController = TextEditingController(text: user?.surname);

    final selectedRole = (user?.role ?? UserRole.admin).obs;
    final selectedCustomerId = (user?.customerId).obs;

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
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Kullanıcı Düzenle' : 'Yeni Kullanıcı Ekle',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
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
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Ad',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ad boş olamaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: surnameController,
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Soyad',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Soyad boş olamaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: usernameController,
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Kullanıcı Adı',
                        prefixIcon: const Icon(Icons.account_circle),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kullanıcı adı boş olamaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: emailController,
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'E-posta',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-posta boş olamaz';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Geçerli bir e-posta adresi giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock),
                        hintText: isEditing
                            ? 'Değiştirmek için yeni şifre giriniz'
                            : 'Şifre giriniz',
                      ),
                      validator: (value) {
                        if (!isEditing && (value == null || value.isEmpty)) {
                          return 'Şifre boş olamaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.p16),
                    Obx(() => DropdownButtonFormField<UserRole>(
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Rol',
                        prefixIcon: const Icon(Icons.admin_panel_settings),
                      ),
                      value: selectedRole.value,
                      items: UserRole.values
                          .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.name),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedRole.value = value;
                          // Eğer admin seçilirse müşteri seçimini temizle
                          if (value == UserRole.admin) {
                            selectedCustomerId.value = null;
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Rol seçiniz';
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: AppSizes.p16),
                    Obx(() => selectedRole.value == UserRole.customer
                        ? DropdownButtonFormField<int?>(
                      decoration: AppDecorations.input.copyWith(
                        labelText: 'Müşteri',
                        prefixIcon: const Icon(Icons.business),
                      ),
                      value: selectedCustomerId.value,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Müşteri Seçiniz'),
                        ),
                        ...customers
                            .map((customer) => DropdownMenuItem(
                          value: customer.id,
                          child: Text(customer.name),
                        ))
                            .toList(),
                      ],
                      onChanged: (value) {
                        selectedCustomerId.value = value;
                      },
                      validator: (value) {
                        if (selectedRole.value == UserRole.customer && value == null) {
                          return 'Müşteri seçiniz';
                        }
                        return null;
                      },
                    )
                        : const SizedBox.shrink()),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: AppSizes.p12),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isEditing) {
                          controller.updateUser(
                            user.id,
                            usernameController.text,
                            passwordController.text.isEmpty
                                ? null
                                : passwordController.text,
                            emailController.text,
                            nameController.text,
                            surnameController.text,
                            selectedRole.value,
                            selectedCustomerId.value,
                          );
                        } else {
                          controller.createUser(
                            usernameController.text,
                            passwordController.text,
                            emailController.text,
                            nameController.text,
                            surnameController.text,
                            selectedRole.value,
                            selectedCustomerId.value,
                          );
                        }
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isEditing ? Icons.save : Icons.add,
                            color: Colors.white),
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

  static void showDeleteDialog(UserViewModel user) {
    final controller = Get.find<UsersController>();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Kullanıcıyı Sil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.name} ${user.surname} kullanıcısını silmek istediğinize emin misiniz?',
              style: const TextStyle(
                  fontSize: AppSizes.p16, color: AppColors.textPrimary),
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
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteUser(user.id);
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
