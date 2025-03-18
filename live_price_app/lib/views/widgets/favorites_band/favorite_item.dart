import 'package:flutter/material.dart';
import 'package:live_price_app/config/theme.dart';
import 'package:live_price_app/models/pair.dart';

class FavoriteItem extends StatelessWidget {
  final Pair pair;

  const FavoriteItem({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .33,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parite adı
              Text(
                pair.displaySymbol ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Fiyat
              Text(
                pair.sellPrice.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Değişim yüzdesi
              Row(
                children: [
                  Text(
                    '%${pair.changePercentage.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: pair.isIncreasing ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (pair.isIncreasing)
                    const Icon(Icons.arrow_upward, size: 12, color: Colors.greenAccent)
                  else
                    const Icon(Icons.arrow_downward, size: 12, color: Colors.redAccent),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: VerticalDivider(color: AppTheme.dividerColor),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
