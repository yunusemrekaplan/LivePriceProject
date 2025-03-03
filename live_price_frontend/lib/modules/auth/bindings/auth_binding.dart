import 'package:get/get.dart';
import 'package:live_price_frontend/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());

    /*
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthController>(() => AuthController());
     */
  }
}
