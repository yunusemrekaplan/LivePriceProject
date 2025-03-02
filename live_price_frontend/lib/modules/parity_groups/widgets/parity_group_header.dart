import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
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
        Text(
          'Parite Grupları',
          style: AppTextStyles.h2,
        ),
        ElevatedButton.icon(
          onPressed: () => ParityGroupDialogs.showAddEditDialog(
            context: Get.context!,
            controller: controller,
          ),
          icon: const Icon(Icons.add),
          label: const Text('Yeni Grup Ekle'),
          style: AppDecorations.elevatedButton,
        ),
      ],
    );
  }
}
