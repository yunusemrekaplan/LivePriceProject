import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';
import '../controllers/parity_groups_controller.dart';

class ParityGroupPagination extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupPagination({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.p8,
        horizontal: AppSizes.p16,
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.currentPage.value > 0
                  ? () =>
                      controller.changePage(controller.currentPage.value - 1)
                  : null,
              color: controller.currentPage.value > 0
                  ? AppColors.primary
                  : AppColors.disabledButton,
              iconSize: AppSizes.icon24,
              splashRadius: AppSizes.icon20,
            ),
            const SizedBox(width: AppSizes.p8),
            Text(
              'Sayfa ${controller.currentPage.value + 1} / ${controller.totalPages}',
              style: AppTextStyles.body1,
            ),
            const SizedBox(width: AppSizes.p8),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.currentPage.value <
                      controller.totalPages - 1
                  ? () =>
                      controller.changePage(controller.currentPage.value + 1)
                  : null,
              color: controller.currentPage.value < controller.totalPages - 1
                  ? AppColors.primary
                  : AppColors.disabledButton,
              iconSize: AppSizes.icon24,
              splashRadius: AppSizes.icon20,
            ),
          ],
        ),
      ),
    );
  }
}
