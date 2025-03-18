import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:live_price_app/config/theme.dart';
import 'package:live_price_app/models/pair.dart';

class PairListItem extends StatelessWidget {
  final Pair pair;

  const PairListItem({super.key, required this.pair});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
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
            pair.displaySymbol,
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
          '%${pair.changePercentage}',
          style: TextStyle(
            fontSize: 14,
            color: pair.isIncreasing ? AppTheme.increaseColor : AppTheme.decreaseColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildTrendIcon(),
      ],
    );
  }

  Widget _buildTrendIcon() {
    if (pair.isIncreasing) {
      return const Icon(
        Icons.arrow_upward,
        size: 14,
        color: AppTheme.increaseColor,
      );
    } else if (pair.changePercentage < 0) {
      return const Icon(
        Icons.arrow_downward,
        size: 14,
        color: AppTheme.decreaseColor,
      );
    }
    return const Icon(
      Icons.remove,
      size: 14,
      color: AppTheme.textSecondaryColor,
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
            pair.displayUpdateTime,
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
    final color = _getPriceColor();

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            pair.buyPrice.toString(),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 80,
          child: Text(
            pair.sellPrice.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _getPriceColor() {
    if (pair.isIncreasing) {
      return AppTheme.increaseColor;
    } else if (pair.changePercentage < 0) {
      return AppTheme.decreaseColor;
    }
    return AppTheme.textPrimaryColor;
  }
}
