import 'package:flutter/material.dart';
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
    return Card(
      child: SingleChildScrollView(
        child: DataTable(
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
      const DataColumn(label: Text('Durum')),
      const DataColumn(label: Text('İşlemler')),
    ];
  }

  DataColumn _buildSortableColumn(String label, String field) {
    return DataColumn(
      label: Row(
        children: [
          Text(label),
          const SizedBox(width: 4),
          if (controller.sortField.value == field)
            Icon(
              controller.sortAscending.value
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
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
          DataCell(Text(group.name)),
          DataCell(Text(group.description)),
          DataCell(Text(group.orderIndex.toString())),
          DataCell(
            Switch(
              value: group.isEnabled,
              onChanged: (value) =>
                  controller.toggleParityGroupStatus(group.id, value),
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
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => ParityGroupDialogs.showDeleteDialog(
                    context: context,
                    controller: controller,
                    group: group,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}
