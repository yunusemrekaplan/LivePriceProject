import 'package:flutter/material.dart';
import '../../../core/theme/app_decorations.dart';
import '../controllers/parity_groups_controller.dart';

class ParityGroupSearchBar extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupSearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card,
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: AppDecorations.input.copyWith(
          hintText: 'Grup ara...',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
