import 'package:get/get.dart';
import 'package:live_price_frontend/modules/parities/models/parity_create_model.dart';
import 'package:live_price_frontend/modules/parities/models/parity_update_model.dart';

import '../../parity_groups/models/parity_group_view_model.dart';
import '../../parity_groups/services/parity_group_service.dart';
import '../models/parity_view_model.dart';
import '../models/spread_rule_type.dart';
import '../services/parity_service.dart';
import '../widgets/parity_dialogs.dart';

class ParitiesController extends GetxController {
  final ParityService _parityService = Get.find<ParityService>();
  final ParityGroupService _parityGroupService = Get.find<ParityGroupService>();

  final RxBool isLoading = false.obs;
  final RxList<ParityViewModel> parities = <ParityViewModel>[].obs;
  final RxList<ParityGroupViewModel> parityGroups =
      <ParityGroupViewModel>[].obs;
  final Rxn<int> selectedGroupId = Rxn<int>();

  // Arama ve filtreleme
  final RxString searchQuery = ''.obs;
  final RxInt selectedGroupFilter = RxInt(-1);

  // Sıralama
  final RxString sortField = 'group'.obs;
  final RxBool sortAscending = true.obs;

  // Sayfalama
  final RxInt currentPage = 0.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalItems = 0.obs;

  // Grup sıralaması için yardımcı metot
  int _getParityGroupOrderIndex(int groupId) {
    final group = parityGroups.firstWhereOrNull((g) => g.id == groupId);
    return group?.orderIndex ?? 0;
  }

  // Seçilen grup için en yüksek sıra numarasını bulma
  int getNextOrderIndexForGroup(int groupId) {
    final groupParities =
        parities.where((p) => p.parityGroupId == groupId).toList();
    if (groupParities.isEmpty) return 1;

    final maxOrderIndex = groupParities
        .map((p) => p.orderIndex)
        .reduce((max, index) => index > max ? index : max);
    return maxOrderIndex + 1;
  }

  // Filtrelenmiş ve sıralanmış pariteler
  List<ParityViewModel> get filteredParities {
    var filtered = List<ParityViewModel>.from(parities);

    // Arama filtresi
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((parity) =>
              parity.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              parity.symbol
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              parity.rawSymbol
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Grup filtresi
    if (selectedGroupFilter.value != -1) {
      filtered = filtered
          .where((parity) => parity.parityGroupId == selectedGroupFilter.value)
          .toList();
    }

    // Sıralama
    filtered.sort((a, b) {
      var comparison = 0;
      switch (sortField.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'symbol':
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case 'apiSymbol':
          comparison = a.rawSymbol.compareTo(b.rawSymbol);
          break;
        case 'orderIndex':
          comparison = a.orderIndex.compareTo(b.orderIndex);
          break;
        case 'scale':
          comparison = a.scale.compareTo(b.scale);
          break;
        case 'group':
          // Önce grupların sıra numarasına göre sırala
          comparison = _getParityGroupOrderIndex(a.parityGroupId)
              .compareTo(_getParityGroupOrderIndex(b.parityGroupId));
          // Eğer aynı gruptalarsa, parite sıra numarasına göre sırala
          if (comparison == 0) {
            comparison = a.orderIndex.compareTo(b.orderIndex);
          }
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });

    // Toplam öğe sayısını güncelle
    totalItems.value = filtered.length;

    return filtered;
  }

  // Sayfalanmış pariteler
  List<ParityViewModel> get paginatedParities {
    final start = currentPage.value * pageSize.value;
    final end = (start + pageSize.value).clamp(0, filteredParities.length);
    return filteredParities.sublist(start, end);
  }

  // Toplam sayfa sayısı
  int get totalPages => (totalItems.value / pageSize.value).ceil();

  // Sayfa değiştirme
  void changePage(int page) {
    if (page >= 0 && page < totalPages) {
      currentPage.value = page;
    }
  }

  // Sıralama değiştirme
  void changeSort(String field) {
    if (sortField.value == field) {
      sortAscending.toggle();
    } else {
      sortField.value = field;
      sortAscending.value = true;
    }
  }

  // Arama sorgusunu güncelleme
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 0; // İlk sayfaya dön
  }

  // Grup filtresini güncelleme
  void updateGroupFilter(int groupId) {
    selectedGroupFilter.value = groupId;
    currentPage.value = 0; // İlk sayfaya dön
  }

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
    String apiSymbol,
    bool isEnabled,
    int orderIndex,
    int scale,
    SpreadRuleType spreadRuleType,
    double spreadForAsk,
    double spreadForBid,
    int parityGroupId,
  ) async {
    try {
      var createModel = ParityCreateModel(
        name: name,
        symbol: symbol,
        rawSymbol: apiSymbol,
        orderIndex: orderIndex,
        parityGroupId: parityGroupId,
        isEnabled: isEnabled,
        scale: scale,
        spreadRuleType: spreadRuleType,
        spreadForAsk: spreadForAsk,
        spreadForBid: spreadForBid,
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
    String apiSymbol,
    bool isEnabled,
    int orderIndex,
    int scale,
    SpreadRuleType spreadRuleType,
    double spreadForAsk,
    double spreadForBid,
    int parityGroupId,
  ) async {
    try {
      var updateModel = ParityUpdateModel(
        name: name,
        symbol: symbol,
        rawSymbol: apiSymbol,
        orderIndex: orderIndex,
        parityGroupId: parityGroupId,
        isEnabled: isEnabled,
        scale: scale,
        spreadRuleType: spreadRuleType,
        spreadForAsk: spreadForAsk,
        spreadForBid: spreadForBid,
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

  void showAddEditDialog({ParityViewModel? parity}) {
    ParityDialogs.showAddEditDialog(parity: parity);
  }

  void showDeleteDialog(ParityViewModel parity) {
    ParityDialogs.showDeleteDialog(parity);
  }
}
