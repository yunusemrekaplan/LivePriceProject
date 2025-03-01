import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}
