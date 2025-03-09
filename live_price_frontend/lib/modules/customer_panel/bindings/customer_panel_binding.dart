import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customer_panel/controllers/customer_panel_controller.dart';
import 'package:live_price_frontend/modules/customer_panel/services/customer_panel_service.dart';

class CustomerPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerPanelService>(() => CustomerPanelService());

    Get.lazyPut<CustomerPanelController>(() => CustomerPanelController());
  }
}
