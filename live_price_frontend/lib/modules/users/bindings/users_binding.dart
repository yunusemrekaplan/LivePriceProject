import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/services/customer_service.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';
import 'package:live_price_frontend/modules/users/services/user_service.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerService>(() => CustomerService());
    Get.lazyPut<UserService>(() => UserService());
    Get.lazyPut<UsersController>(() => UsersController());
  }
}
