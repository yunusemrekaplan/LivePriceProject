import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

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
                  'Müşteriler',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: controller.showCreateDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Müşteri'),
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
                              DataColumn(label: Text('API Key')),
                              DataColumn(label: Text('İşlemler')),
                            ],
                            rows: controller.customers
                                .map(
                                  (customer) => DataRow(
                                    cells: [
                                      DataCell(Text(customer.id.toString())),
                                      DataCell(Text(customer.name)),
                                      DataCell(Text(customer.apiKey)),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => controller
                                                  .showEditDialog(customer),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => controller
                                                  .showDeleteDialog(customer),
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
