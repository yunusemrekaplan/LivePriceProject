import 'package:get/get.dart';
import '../controllers/parities_controller.dart';
import '../services/parities_service.dart';
import '../../parity_groups/services/parity_groups_service.dart';

class ParitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParitiesService());
    Get.lazyPut(() => ParityGroupsService());
    Get.lazyPut(() => ParitiesController());
  }
}
