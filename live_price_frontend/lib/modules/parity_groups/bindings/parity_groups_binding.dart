import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parity_groups/controllers/parity_groups_controller.dart';

class ParityGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParityGroupsController>(() => ParityGroupsController());
  }
}
