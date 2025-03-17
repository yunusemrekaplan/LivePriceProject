import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/parity_model.dart';

class FavoritesBand extends StatelessWidget {
  final List<Parity> favorites;
  final VoidCallback onAddPressed;

  const FavoritesBand({super.key, required this.favorites, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      height: 90,
      child: Row(
        children: [
          // Favoriler listesi
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final parity = favorites[index];
                return FavoriteItem(parity: parity);
              },
            ),
          ),

          // Ekleme butonu
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppTheme.primaryColor),
              onPressed: onAddPressed,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Parity parity;

  const FavoriteItem({super.key, required this.parity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parite adı
          Text(
            parity.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Fiyat
          Text(
            _formatPrice(parity.buyPrice),
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
                '%${parity.changePercentage.toStringAsFixed(4)}',
                style: TextStyle(
                  fontSize: 12,
                  color: parity.isIncreasing ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (parity.isIncreasing)
                const Icon(Icons.arrow_upward, size: 12, color: Colors.greenAccent)
              else
                const Icon(Icons.arrow_downward, size: 12, color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    // 1'den küçük değerler için farklı format
    if (price < 1) {
      return price.toStringAsFixed(4);
    }
    // 100'den küçük değerler için
    else if (price < 100) {
      return price.toStringAsFixed(4);
    }
    // Büyük değerler için binlik ayırıcı formatı
    else {
      final String priceStr = price.toStringAsFixed(2);
      // Binlik ayırıcı ekleme
      final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String mathFunc(Match match) => '${match[1]}.';
      return priceStr.replaceAllMapped(reg, mathFunc);
    }
  }
}

class GoldFavoritesBand extends StatelessWidget {
  final List<GoldItem> favorites;
  final VoidCallback onAddPressed;

  const GoldFavoritesBand({
    super.key,
    required this.favorites,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      height: 80,
      child: Row(
        children: [
          // Favoriler listesi
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final goldItem = favorites[index];
                return GoldFavoriteItem(goldItem: goldItem);
              },
            ),
          ),

          // Ekleme butonu
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.add, color: AppTheme.primaryColor),
                onPressed: onAddPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoldFavoriteItem extends StatelessWidget {
  final GoldItem goldItem;

  const GoldFavoriteItem({super.key, required this.goldItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white24, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Altın adı
          Text(
            goldItem.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Fiyat
          Text(
            _formatPrice(goldItem.buyPrice),
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
                '%${goldItem.changePercentage.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: goldItem.isIncreasing ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (goldItem.isIncreasing)
                const Icon(Icons.arrow_upward, size: 12, color: Colors.greenAccent)
              else if (goldItem.changePercentage < 0)
                const Icon(Icons.arrow_downward, size: 12, color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      // Binlik ayırıcı ekleme
      final String priceStr = price.toStringAsFixed(2);
      final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String Function(Match) mathFunc = (Match match) => '${match[1]}.';
      return priceStr.replaceAllMapped(reg, mathFunc);
    } else {
      return price.toStringAsFixed(2);
    }
  }
}
