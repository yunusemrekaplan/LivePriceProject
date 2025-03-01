import 'package:get/get.dart';
import 'package:live_price_frontend/modules/users/controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(() => UsersController());
  }
}
