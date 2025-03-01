import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parity_groups/controllers/parity_groups_controller.dart';

class ParityGroupsView extends GetView<ParityGroupsController> {
  const ParityGroupsView({super.key});

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
                  'Parite Grupları',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: controller.showCreateDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Grup'),
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
                              DataColumn(label: Text('Sıra')),
                              DataColumn(label: Text('Durum')),
                              DataColumn(label: Text('İşlemler')),
                            ],
                            rows: controller.parityGroups
                                .map(
                                  (group) => DataRow(
                                    cells: [
                                      DataCell(Text(group.id.toString())),
                                      DataCell(Text(group.name)),
                                      DataCell(
                                          Text(group.orderIndex.toString())),
                                      DataCell(
                                        Switch(
                                          value: group.isEnabled,
                                          onChanged: (value) =>
                                              controller.updateParityGroup(
                                            group.id,
                                            {'isEnabled': value},
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => controller
                                                  .showEditDialog(group),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => controller
                                                  .showDeleteDialog(group),
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
