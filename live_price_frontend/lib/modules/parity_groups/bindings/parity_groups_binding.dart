import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parity_groups/controllers/parity_groups_controller.dart';
import 'package:live_price_frontend/modules/parity_groups/services/parity_group_service.dart';

class ParityGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParityGroupService>(() => ParityGroupService());
    Get.lazyPut<ParityGroupsController>(() => ParityGroupsController());
  }
}