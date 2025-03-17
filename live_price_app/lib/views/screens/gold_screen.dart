import 'package:flutter/material.dart';
import '../../models/parity_model.dart';
import '../widgets/parity_list_item.dart';
import '../widgets/favorites_band.dart';

class GoldScreen extends StatelessWidget {
  final VoidCallback onAddFavoritePressed;

  const GoldScreen({super.key, required this.onAddFavoritePressed});

  @override
  Widget build(BuildContext context) {
    // Örnek veri
    final goldItems = GoldItem.getDummyData();
    final favorites = GoldItem.getFavoritesData();

    return Column(
      children: [
        // Favoriler bandı
        GoldFavoritesBand(
          favorites: favorites,
          onAddPressed: onAddFavoritePressed,
        ),

        // Altın listesi
        Expanded(
          child: ListView.builder(
            itemCount: goldItems.length,
            itemBuilder: (context, index) {
              return GoldListItem(goldItem: goldItems[index]);
            },
          ),
        ),
      ],
    );
  }
}
