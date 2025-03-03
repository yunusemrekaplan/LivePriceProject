import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_decorations.dart';
import 'package:live_price_frontend/core/theme/app_sizes.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';
import 'package:live_price_frontend/modules/users/models/user_role.dart';

class UserHeader extends GetView<UsersController> {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kullanıcılar', style: AppTextStyles.h2),
            ElevatedButton.icon(
              onPressed: () => controller.showAddEditDialog(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Yeni Kullanıcı',
                  style: TextStyle(color: Colors.white)),
              style: AppDecorations.elevatedButton,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p24),
        TextField(
          onChanged: controller.updateSearchQuery,
          decoration: AppDecorations.input.copyWith(
            hintText: 'Kullanıcı ara...',
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        Row(
          children: [
            // Rol filtresi
            Expanded(
              child: Obx(() => DropdownButtonFormField<int>(
                    decoration: AppDecorations.input.copyWith(
                      labelText: 'Rol Filtresi',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    value: controller.selectedRoleFilter.value >= 0
                        ? controller.selectedRoleFilter.value
                        : -1,
                    items: [
                      const DropdownMenuItem(
                        value: -1,
                        child: Text('Tüm Roller'),
                      ),
                      ...UserRole.values
                          .map((role) => DropdownMenuItem(
                                value: role.id,
                                child: Text(role.name),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateRoleFilter(value);
                      }
                    },
                  )),
            ),
            const SizedBox(width: AppSizes.p16),
            // Müşteri filtresi
            Expanded(
              child: Obx(() => DropdownButtonFormField<int>(
                    decoration: AppDecorations.input.copyWith(
                      labelText: 'Müşteri Filtresi',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    value: controller.selectedCustomerFilter.value >= 0
                        ? controller.selectedCustomerFilter.value
                        : -1,
                    items: [
                      const DropdownMenuItem(
                        value: -1,
                        child: Text('Tüm Müşteriler'),
                      ),
                      ...controller.customers
                          .map((customer) => DropdownMenuItem(
                                value: customer.id,
                                child: Text(customer.name),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateCustomerFilter(value);
                      }
                    },
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
