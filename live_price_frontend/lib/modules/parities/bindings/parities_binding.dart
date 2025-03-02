import 'package:get/get.dart';
import '../controllers/parities_controller.dart';
import '../services/parity_service.dart';
import '../../parity_groups/services/parity_group_service.dart';

class ParitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParityService());
    Get.lazyPut(() => ParityGroupService());
    Get.lazyPut(() => ParitiesController());
  }
}
