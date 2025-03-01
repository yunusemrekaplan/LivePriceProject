import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          _buildUserMenu(),
        ],
      ),
      drawer: _buildDrawer(),
      body: child,
    );
  }

  Widget _buildUserMenu() {
    //final authService = Get.find<AuthService>();

    return PopupMenuButton(
      icon: const Icon(Icons.account_circle),
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          child: const Text('Kullanıcı: '),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Text('Çıkış Yap'),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          //authService.logout();
          Get.offAllNamed('/login');
        }
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Live Price Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Yönetim Paneli',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            icon: Icons.currency_exchange,
            title: 'Pariteler',
            route: '/parities',
          ),
          _buildMenuItem(
            icon: Icons.folder,
            title: 'Parite Grupları',
            route: '/parity-groups',
          ),
          _buildMenuItem(
            icon: Icons.people,
            title: 'Kullanıcılar',
            route: '/users',
          ),
          _buildMenuItem(
            icon: Icons.business,
            title: 'Müşteriler',
            route: '/customers',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Get.back(); // Drawer'ı kapat
        Get.toNamed(route);
      },
    );
  }
}
