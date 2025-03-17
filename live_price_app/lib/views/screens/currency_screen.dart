import 'package:flutter/material.dart';
import 'package:live_price_app/views/widgets/parity_list_view.dart';

import '../../models/parity_model.dart';
import '../widgets/favorites_band.dart';

class CurrencyScreen extends StatelessWidget {
  final VoidCallback onAddFavoritePressed;

  const CurrencyScreen({super.key, required this.onAddFavoritePressed});

  @override
  Widget build(BuildContext context) {
    // Örnek veri
    final parities = Parity.getDummyData();
    final favorites = Parity.getFavoritesData();

    return Column(
      children: [
        // Favoriler bandı
        FavoritesBand(
          favorites: favorites,
          onAddPressed: onAddFavoritePressed,
        ),

        // Parite listesi
        Expanded(
          child: SingleChildScrollView(
            child: ParityListView(parities: parities),
          ),
        ),
      ],
    );
  }
}
