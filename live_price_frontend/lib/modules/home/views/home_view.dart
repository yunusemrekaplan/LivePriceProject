import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/layout/admin_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Ana Sayfa',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hoş Geldiniz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: _calculateCrossAxisCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildModuleCard(
                  title: 'Pariteler',
                  icon: Icons.currency_exchange,
                  route: '/parities',
                  description: 'Pariteleri görüntüle, ekle, düzenle ve sil',
                ),
                _buildModuleCard(
                  title: 'Parite Grupları',
                  icon: Icons.folder,
                  route: '/parity-groups',
                  description: 'Parite gruplarını yönet',
                ),
                _buildModuleCard(
                  title: 'Kullanıcılar',
                  icon: Icons.people,
                  route: '/users',
                  description: 'Kullanıcıları görüntüle ve yönet',
                ),
                _buildModuleCard(
                  title: 'Müşteriler',
                  icon: Icons.business,
                  route: '/customers',
                  description: 'Müşteri bilgilerini yönet',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required String route,
    required String description,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Get.toNamed(route),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Get.theme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
