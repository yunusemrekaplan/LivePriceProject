import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_app/controllers/pairs_controller.dart';
import '../../../config/theme.dart';
import 'favorite_item.dart';

class FavoritesBand extends StatelessWidget {
  const FavoritesBand({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PairsController>();

    return Obx(
      () => Container(
        width: double.infinity,
        color: AppTheme.primaryColor,
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Favoriler listesi
            Expanded(
              child: CarouselSlider(
                items: controller.favorites
                    .map(
                      (pair) => FavoriteItem(pair: pair),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 90,
                  viewportFraction: .35,
                  padEnds: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(milliseconds: 3000),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                ),
              ),
            ),

            // Ekleme butonu
            IconButton(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              // Varsayılan boyut kısıtlamalarını kaldır
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(const CircleBorder()),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppTheme.textPrimaryColor, size: 24),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
