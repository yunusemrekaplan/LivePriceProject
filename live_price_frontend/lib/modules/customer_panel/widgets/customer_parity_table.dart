import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_colors.dart';
import 'package:live_price_frontend/core/theme/app_text_styles.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_view_model.dart';

class CustomerParityTable extends GetView<CustomerPanelController> {
  const CustomerParityTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error.value.isNotEmpty) {
            return Center(child: Text(controller.error.value));
          }

          if (controller.filteredCustomerParities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_exchange,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gösterilecek döviz kuru bulunamadı.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Theme(
                    data: Theme.of(Get.context!).copyWith(
                      cardColor: Colors.white,
                      dividerColor: Colors.grey[200],
                    ),
                    child: DataTable(
                      columnSpacing: 42,
                      horizontalMargin: 32,
                      headingRowHeight: 56,
                      dataRowMaxHeight: 52,
                      dataRowMinHeight: 52,
                      columns: _buildColumns(),
                      rows: _buildParityRows(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(
        label: Text(
          'Döviz Kuru',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Sembol',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Spread Tipi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Alış Spread',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Satış Spread',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'Görünür',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      DataColumn(
        label: Text(
          'İşlemler',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    ];
  }

  List<DataRow> _buildParityRows() {
    return controller.filteredCustomerParities.map((parity) {
      return DataRow(
        cells: [
          DataCell(Text(parity.name, style: AppTextStyles.tableCell)),
          DataCell(Text(parity.symbol, style: AppTextStyles.tableCell)),
          DataCell(Text(
              parity.spreadRuleType == SpreadRuleType.percentage
                  ? 'Yüzde'
                  : parity.spreadRuleType == SpreadRuleType.fixed
                      ? 'Sabit'
                      : '-',
              style: AppTextStyles.tableCell)),
          DataCell(Text(parity.spreadForAsk?.toString() ?? '-',
              style: AppTextStyles.tableCell)),
          DataCell(Text(parity.spreadForBid?.toString() ?? '-',
              style: AppTextStyles.tableCell)),
          DataCell(
            Switch(
              value: parity.isVisible,
              onChanged: (value) =>
                  controller.toggleParityVisibility(parity.id, value),
              activeColor: AppColors.switchActive,
              inactiveTrackColor: AppColors.switchInactive,
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () => _showEditDialog(parity),
                  tooltip: 'Düzenle',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  void _showEditDialog(CParityViewModel parity) {
    // Rule varsa o rule'u al yoksa yeni bir rule oluştur
    final existingRule = controller.parityRules
        .firstWhereOrNull((rule) => rule.parityId == parity.id);

    if (existingRule != null) {
      controller.setParityRuleFormValues(existingRule);
    } else {
      controller.parityRuleIsVisible.value = parity.isVisible;
      controller.parityRuleSpreadType.value = parity.spreadRuleType;
      controller.parityRuleSpreadForAsk.value = parity.spreadForAsk;
      controller.parityRuleSpreadForBid.value = parity.spreadForBid;
    }

    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: Text('Döviz Kuru Düzenle: ${parity.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => DropdownButtonFormField<SpreadRuleType>(
                          decoration: const InputDecoration(
                            labelText: 'Spread Tipi',
                            border: OutlineInputBorder(),
                          ),
                          value: controller.parityRuleSpreadType.value,
                          items: SpreadRuleType.values
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                        type == SpreadRuleType.percentage
                                            ? 'Yüzde'
                                            : 'Sabit'),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              controller.parityRuleSpreadType.value = value,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Alış Spread',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue:
                          controller.parityRuleSpreadForAsk.value?.toString() ??
                              '',
                      onChanged: (value) =>
                          controller.parityRuleSpreadForAsk.value =
                              value.isEmpty ? null : double.tryParse(value),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Geçerli bir sayı giriniz';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Satış Spread',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue:
                          controller.parityRuleSpreadForBid.value?.toString() ??
                              '',
                      onChanged: (value) =>
                          controller.parityRuleSpreadForBid.value =
                              value.isEmpty ? null : double.tryParse(value),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Geçerli bir sayı giriniz';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
                if (existingRule != null) {
                  controller.updateParityRule(existingRule.id);
                } else {
                  controller.createParityRule(parity.id);
                }
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
