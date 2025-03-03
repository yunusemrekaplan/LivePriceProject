import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/controllers/customers_controller.dart';
import 'package:live_price_frontend/modules/customers/services/customer_service.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerService>(() => CustomerService());
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}
