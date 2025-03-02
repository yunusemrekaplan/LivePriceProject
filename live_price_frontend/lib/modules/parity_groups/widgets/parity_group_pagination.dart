import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/parity_groups_controller.dart';

class ParityGroupPagination extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupPagination({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.currentPage.value > 0
                ? () => controller.changePage(controller.currentPage.value - 1)
                : null,
          ),
          Text(
            'Sayfa ${controller.currentPage.value + 1} / ${controller.totalPages}',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.currentPage.value < controller.totalPages - 1
                ? () => controller.changePage(controller.currentPage.value + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
