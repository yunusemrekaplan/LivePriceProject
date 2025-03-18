import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_app/views/widgets/favorites_band/favorites_band.dart';

import '../../controllers/pairs_controller.dart';
import '../widgets/pair_list_view.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX controller
    final controller = Get.find<PairsController>();

    return Obx(() {
      if (controller.isLoading.value && controller.currencyPairs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.currencyPairs.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.currency_exchange,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Henüz döviz verisi yok',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Favoriler bandı
          const FavoritesBand(),

          // Parite listesi
          PairListView(pairs: controller.currencyPairs),
        ],
      );
    });
  }
}
