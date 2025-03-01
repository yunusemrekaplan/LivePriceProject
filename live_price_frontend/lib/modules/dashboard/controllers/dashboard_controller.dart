import 'package:get/get.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  void onMenuItemSelected(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed(Routes.parities);
        break;
      case 1:
        Get.toNamed(Routes.parityGroups);
        break;
      case 2:
        Get.toNamed(Routes.users);
        break;
      case 3:
        Get.toNamed(Routes.customers);
        break;
    }
  }

  void logout() {
    Get.offAllNamed(Routes.login);
  }
}
