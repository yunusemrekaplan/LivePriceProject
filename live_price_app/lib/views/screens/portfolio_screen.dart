import 'package:flutter/material.dart';
import '../../config/theme.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // İkon
          Icon(
            Icons.account_balance_wallet,
            size: 80,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),

          // Başlık
          const Text(
            "Portföy",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Açıklama
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Portföy özelliği yakında eklenecektir. Burada yatırımlarınızı takip edebileceksiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Buton
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Bildirim Al"),
          ),
        ],
      ),
    );
  }
}
