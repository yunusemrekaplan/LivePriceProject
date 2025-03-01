import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kullanıcılar',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: controller.showCreateDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Kullanıcı'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Ad')),
                              DataColumn(label: Text('Soyad')),
                              DataColumn(label: Text('Kullanıcı Adı')),
                              DataColumn(label: Text('E-posta')),
                              DataColumn(label: Text('Rol')),
                              DataColumn(label: Text('Müşteri')),
                              DataColumn(label: Text('İşlemler')),
                            ],
                            rows: controller.users
                                .map(
                                  (user) => DataRow(
                                    cells: [
                                      DataCell(Text(user.id.toString())),
                                      DataCell(Text(user.name)),
                                      DataCell(Text(user.surname)),
                                      DataCell(Text(user.username)),
                                      DataCell(Text(user.email)),
                                      DataCell(Text(user.role.displayName)),
                                      DataCell(Text(user.customerName ?? '-')),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => controller
                                                  .showEditDialog(user),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => controller
                                                  .showDeleteDialog(user),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
