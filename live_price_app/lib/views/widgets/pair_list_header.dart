import 'package:flutter/material.dart';
import 'package:live_price_app/config/theme.dart';

class PairListHeader extends StatelessWidget {
  const PairListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Parite',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Alış',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(width: 24),
              SizedBox(
                width: 80,
                child: Text(
                  'Satış',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
