import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parities/controllers/parities_controller.dart';

class ParitiesView extends GetView<ParitiesController> {
  const ParitiesView({super.key});

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
                  'Pariteler',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: controller.showCreateDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Parite'),
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
                              DataColumn(label: Text('Sembol')),
                              DataColumn(label: Text('Grup')),
                              DataColumn(label: Text('Sıra')),
                              DataColumn(label: Text('Durum')),
                              DataColumn(label: Text('İşlemler')),
                            ],
                            rows: controller.parities
                                .map(
                                  (parity) => DataRow(
                                    cells: [
                                      DataCell(Text(parity.id.toString())),
                                      DataCell(Text(parity.name)),
                                      DataCell(Text(parity.symbol)),
                                      DataCell(
                                          Text(parity.parityGroupName ?? '-')),
                                      DataCell(
                                          Text(parity.orderIndex.toString())),
                                      DataCell(
                                        Switch(
                                          value: parity.isEnabled,
                                          onChanged: (value) =>
                                              controller.updateParity(
                                            parity.id,
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
                                                  .showEditDialog(parity),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => controller
                                                  .showDeleteDialog(parity),
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
