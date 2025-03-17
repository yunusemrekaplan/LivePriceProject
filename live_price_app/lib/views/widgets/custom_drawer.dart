import 'package:flutter/material.dart';
import '../../config/theme.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onCategorySelected;
  final int selectedIndex;

  const CustomDrawer({
    Key? key,
    required this.onCategorySelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer başlığı
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "ASK",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Uygulama adı
                const Text(
                  "Canlı Fiyat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Kategoriler
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildCategoryItem(0, Icons.currency_exchange, "Döviz"),
                _buildCategoryItem(1, Icons.monetization_on, "Altın"),
                _buildCategoryItem(2, Icons.currency_bitcoin, "Kripto"),
                _buildCategoryItem(3, Icons.show_chart, "Borsa"),
                _buildCategoryItem(4, Icons.oil_barrel, "Emtia"),
                const Divider(),
                _buildMenuItem(Icons.palette, "Tema", () {
                  // Tema değiştirme fonksiyonu
                }),
                _buildMenuItem(Icons.notifications, "Bildirimler", () {
                  // Bildirimler sayfasına yönlendirme
                }),
                _buildMenuItem(Icons.settings, "Ayarlar", () {
                  // Ayarlar sayfasına yönlendirme
                }),
                const Divider(),
                _buildMenuItem(Icons.info, "Hakkında", () {
                  // Hakkında sayfasına yönlendirme
                }),
                _buildMenuItem(Icons.help, "Yardım", () {
                  // Yardım sayfasına yönlendirme
                }),
              ],
            ),
          ),

          // Alt kısım
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Versiyon
                const Text(
                  "Versiyon 1.0.0",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                // Giriş/Çıkış
                TextButton.icon(
                  icon: const Icon(Icons.login, size: 16),
                  label: const Text("Giriş Yap"),
                  onPressed: () {
                    // Giriş sayfasına yönlendirme
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor:
          isSelected ? AppTheme.primaryLightColor.withOpacity(0.2) : null,
      selected: isSelected,
      onTap: () => onCategorySelected(index),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondaryColor),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
