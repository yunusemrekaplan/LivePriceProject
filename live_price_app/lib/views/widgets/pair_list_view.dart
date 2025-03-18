import 'package:flutter/material.dart';
import 'package:live_price_app/models/pair.dart';
import 'package:live_price_app/views/widgets/pair_list_header.dart';

import 'pair_list_item.dart';

class PairListView extends StatelessWidget {
  final List<Pair> pairs;

  const PairListView({super.key, required this.pairs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PairListHeader(),
        const Divider(height: 1, thickness: 1),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pairs.length,
          itemBuilder: (context, index) => PairListItem(pair: pairs[index]),
        ),
      ],
    );
  }
}
