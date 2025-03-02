import 'package:flutter/material.dart';
import '../controllers/parity_groups_controller.dart';

class ParityGroupSearchBar extends StatelessWidget {
  final ParityGroupsController controller;

  const ParityGroupSearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.updateSearchQuery,
      decoration: InputDecoration(
        hintText: 'Grup ara...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
