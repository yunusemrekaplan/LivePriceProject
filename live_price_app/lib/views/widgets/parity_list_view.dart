import 'package:flutter/material.dart';
import 'package:live_price_app/models/parity_model.dart';
import 'package:live_price_app/views/widgets/parity_list_header.dart';

import 'parity_list_item.dart';

class ParityListView extends StatelessWidget {
  final List<Parity> parities;

  const ParityListView({super.key, required this.parities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ParityListHeader(),
        const Divider(height: 1, thickness: 1),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parities.length,
          itemBuilder: (context, index) =>
              ParityListItem(parity: parities[index]),
        ),
      ],
    );
  }
}

