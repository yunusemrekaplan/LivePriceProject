import 'package:get/get.dart';
import '../services/signalr_service.dart';
import '../controllers/pairs_controller.dart';

/// Uygulama başlatıldığında gerekli bağımlılıkları enjekte eder
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Servisler
    Get.put<SignalRService>(SignalRService(), permanent: true);

    // Controller'lar
    Get.put<PairsController>(PairsController(), permanent: true);
  }
}
