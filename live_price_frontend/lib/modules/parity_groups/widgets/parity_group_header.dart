import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/theme/app_theme.dart';
import '../controllers/parity_groups_controller.dart';
import 'parity_group_dialogs.dart';

class ParityGroupHeader extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Parite Grupları',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => ParityGroupDialogs.showAddEditDialog(
            context: Get.context!,
            controller: controller,
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Yeni Grup Ekle'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
