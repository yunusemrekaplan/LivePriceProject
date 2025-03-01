import 'package:get/get.dart';
import 'package:live_price_frontend/modules/auth/controllers/auth_controller.dart';
import 'package:live_price_frontend/modules/auth/services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
