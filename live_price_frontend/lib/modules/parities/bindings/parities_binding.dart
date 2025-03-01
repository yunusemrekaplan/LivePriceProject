import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parities/controllers/parities_controller.dart';

class ParitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParitiesController>(() => ParitiesController());
  }
}
