import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parities/models/parity_create_model.dart';
import 'package:live_price_frontend/modules/parities/models/parity_update_model.dart';
import '../models/parity_view_model.dart';
import '../services/parity_service.dart';
import '../../parity_groups/models/parity_group_view_model.dart';
import '../../parity_groups/services/parity_group_service.dart';

class ParitiesController extends GetxController {
  final ParityService _parityService = Get.find<ParityService>();
  final ParityGroupService _parityGroupService =
  Get.find<ParityGroupService>();

  final RxBool isLoading = false.obs;
  final RxList<ParityViewModel> parities = <ParityViewModel>[].obs;
  final RxList<ParityGroupViewModel> parityGroups =
      <ParityGroupViewModel>[].obs;
  final Rxn<int> selectedGroupId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchParities();
    fetchParityGroups();
  }

  Future<void> fetchParities() async {
    isLoading.value = true;
    try {
      final response = await _parityService.getParities();
      if (response.success) {
        parities.assignAll(response.data ?? []);
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Pariteler yüklenirken bir hata oluştu');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchParityGroups() async {
    try {
      final response = await _parityGroupService.getParityGroups();
      if (response.success) {
        parityGroups.assignAll(response.data ?? []);
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite grupları yüklenirken bir hata oluştu');
    }
  }

  String getParityGroupName(int groupId) {
    final group = parityGroups.firstWhereOrNull((g) => g.id == groupId);
    return group?.name ?? 'Bilinmeyen Grup';
  }

  Future<void> createParity(
      String name,
      String symbol,
      bool isEnabled,
      int orderIndex,
      int parityGroupId,
      ) async {
    try {
      var createModel = ParityCreateModel(
        name: name,
        symbol: symbol,
        orderIndex: orderIndex,
        parityGroupId: parityGroupId,
        isEnabled: isEnabled,
      );
      final response =
      await _parityService.createParity(parityCreateModel: createModel);

      if (response.success) {
        await fetchParities();
        Get.snackbar('Başarılı', 'Parite başarıyla eklendi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Parite eklenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite eklenirken bir hata oluştu');
    }
  }

  Future<void> updateParity(
      int id,
      String name,
      String symbol,
      bool isEnabled,
      int orderIndex,
      int parityGroupId,
      ) async {
    try {
      var updateModel = ParityUpdateModel(
        name: name,
        symbol: symbol,
        orderIndex: orderIndex,
        parityGroupId: parityGroupId,
        isEnabled: isEnabled,
      );

      final response = await _parityService.updateParity(
          id: id, parityUpdateModel: updateModel);

      if (response.success) {
        await fetchParities();
        Get.snackbar('Başarılı', 'Parite başarıyla güncellendi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite güncellenirken bir hata oluştu');
    }
  }

  Future<void> deleteParity(int id) async {
    try {
      final response = await _parityService.deleteParity(id);

      if (response.success) {
        await fetchParities();
        Get.snackbar('Başarılı', 'Parite başarıyla silindi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Parite silinirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite silinirken bir hata oluştu');
    }
  }

  Future<void> toggleParityStatus(int id, bool isEnabled) async {
    try {
      final response = await _parityService.updateParityStatus(id, isEnabled);

      if (response.success) {
        await fetchParities();
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite durumu güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite durumu güncellenirken bir hata oluştu');
    }
  }
}
