import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';
import '../controllers/parity_groups_controller.dart';
import 'parity_group_dialogs.dart';

class ParityGroupTable extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupTable({
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radius8),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.tableHeader),
          dataRowHeight: AppSizes.tableRowHeight,
          headingRowHeight: AppSizes.tableHeaderHeight,
          horizontalMargin: AppSizes.p24,
          columnSpacing: AppSizes.p24,
          columns: _buildColumns(),
          rows: _buildRows(context),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildSortableColumn('İsim', 'name'),
      _buildSortableColumn('Açıklama', 'description'),
      _buildSortableColumn('Sıra', 'orderIndex'),
      const DataColumn(
        label: Text(
          'Durum',
          style: AppTextStyles.tableHeader,
        ),
      ),
      const DataColumn(
        label: Text(
          'İşlemler',
          style: AppTextStyles.tableHeader,
        ),
      ),
    ];
  }

  DataColumn _buildSortableColumn(String label, String field) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.tableHeader,
          ),
          const SizedBox(width: 4),
          if (controller.sortField.value == field)
            Icon(
              controller.sortAscending.value
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: AppSizes.icon16,
              color: AppColors.primary,
            ),
        ],
      ),
      onSort: (_, __) => controller.changeSort(field),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    return controller.paginatedGroups.map((group) {
      return DataRow(
        cells: [
          DataCell(Text(
            group.name,
            style: AppTextStyles.tableCell,
          )),
          DataCell(Text(
            group.description,
            style: AppTextStyles.tableCell,
          )),
          DataCell(Text(
            group.orderIndex.toString(),
            style: AppTextStyles.tableCell,
          )),
          DataCell(
            Switch(
              value: group.isEnabled,
              onChanged: (value) =>
                  controller.toggleParityGroupStatus(group.id, value),
              activeColor: AppColors.primary,
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => ParityGroupDialogs.showAddEditDialog(
                    context: context,
                    controller: controller,
                    group: group,
                  ),
                  color: AppColors.primary,
                  iconSize: AppSizes.icon20,
                  splashRadius: AppSizes.icon20,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => ParityGroupDialogs.showDeleteDialog(
                    context: context,
                    controller: controller,
                    group: group,
                  ),
                  color: Colors.red,
                  iconSize: AppSizes.icon20,
                  splashRadius: AppSizes.icon20,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}
