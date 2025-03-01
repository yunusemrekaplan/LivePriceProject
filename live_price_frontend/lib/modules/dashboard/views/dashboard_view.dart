import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Price Admin'),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: controller.onMenuItemSelected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.currency_exchange),
                label: Text('Pariteler'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder),
                label: Text('Parite Grupları'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Kullanıcılar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.business),
                label: Text('Müşteriler'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: GetRouterOutlet(
              initialRoute: '/parities',
              anchorRoute: '/dashboard',
            ),
          ),
        ],
      ),
    );
  }
}
