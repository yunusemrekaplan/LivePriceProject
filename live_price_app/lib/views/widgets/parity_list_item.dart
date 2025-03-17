import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/parity_model.dart';

class ParityListItem extends StatelessWidget {
  final Parity parity;

  const ParityListItem({super.key, required this.parity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSymbolSection(),
                _buildTimeSection(),
                const SizedBox(width: 16),
                _buildPriceSection(),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppTheme.dividerColor),
        ],
      ),
    );
  }

  Widget _buildSymbolSection() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parity.symbol,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          _buildChangePercentage(),
        ],
      ),
    );
  }

  Widget _buildChangePercentage() {
    return Row(
      children: [
        Text(
          '%${parity.changePercentage.toStringAsFixed(4)}',
          style: TextStyle(
            fontSize: 12,
            color: parity.isIncreasing
                ? AppTheme.increaseColor
                : AppTheme.decreaseColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildTrendIcon(),
      ],
    );
  }

  Widget _buildTrendIcon() {
    return Icon(
      parity.isIncreasing ? Icons.arrow_upward : Icons.arrow_downward,
      size: 12,
      color:
          parity.isIncreasing ? AppTheme.increaseColor : AppTheme.decreaseColor,
    );
  }

  Widget _buildTimeSection() {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            size: 12,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            parity.updateTime,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            _formatPrice(parity.buyPrice),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 80,
          child: Text(
            _formatPrice(parity.sellPrice),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price < 1 || price < 100) {
      return price.toStringAsFixed(4);
    }
    return _addThousandSeparator(price.toStringAsFixed(2));
  }

  String _addThousandSeparator(String priceStr) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]}.';
    return priceStr.replaceAllMapped(reg, mathFunc);
  }
}

class GoldListItem extends StatelessWidget {
  final GoldItem goldItem;

  const GoldListItem({super.key, required this.goldItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSymbolSection(),
                _buildTimeSection(),
                _buildPriceSection(),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }

  // Sol taraf - Altın adı ve değişim yüzdesi
  Widget _buildSymbolSection() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goldItem.symbol,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _buildChangePercentage(),
        ],
      ),
    );
  }

  // Değişim yüzdesi satırı
  Widget _buildChangePercentage() {
    return Row(
      children: [
        Text(
          '%${goldItem.changePercentage.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            color: goldItem.isIncreasing
                ? AppTheme.increaseColor
                : AppTheme.decreaseColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildTrendIcon(),
      ],
    );
  }

  // Trend ikonu (yukarı/aşağı ok)
  Widget _buildTrendIcon() {
    if (goldItem.isIncreasing) {
      return const Icon(Icons.arrow_upward,
          size: 14, color: AppTheme.increaseColor);
    } else if (goldItem.changePercentage < 0) {
      return const Icon(Icons.arrow_downward,
          size: 14, color: AppTheme.decreaseColor);
    }
    return const SizedBox.shrink();
  }

  // Orta - Güncelleme zamanı
  Widget _buildTimeSection() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            size: 12,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            goldItem.updateTime,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Sağ taraf - Alış/Satış fiyatları
  Widget _buildPriceSection() {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPriceColumn('Alış', goldItem.buyPrice),
          _buildPriceColumn('Satış', goldItem.sellPrice),
        ],
      ),
    );
  }

  // Fiyat kolonu (Alış veya Satış)
  Widget _buildPriceColumn(String label, double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatPrice(price),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getPriceColor(),
              ),
            ),
            _buildTrendIcon(),
          ],
        ),
      ],
    );
  }

  Color _getPriceColor() {
    if (goldItem.isIncreasing) {
      return AppTheme.increaseColor;
    } else if (goldItem.changePercentage < 0) {
      return AppTheme.decreaseColor;
    }
    return AppTheme.textPrimaryColor;
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return _addThousandSeparator(price.toStringAsFixed(2));
    }
    return price.toStringAsFixed(2);
  }

  String _addThousandSeparator(String priceStr) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]}.';
    return priceStr.replaceAllMapped(reg, mathFunc);
  }
}
