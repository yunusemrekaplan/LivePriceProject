import 'package:get/get.dart';
import '../models/parity_group_view_model.dart';
import '../models/parity_group_create_model.dart';
import '../models/parity_group_update_model.dart';
import '../services/parity_group_service.dart';

class ParityGroupsController extends GetxController {
  final ParityGroupService _parityGroupService = Get.find<ParityGroupService>();

  final RxBool isLoading = false.obs;
  final RxList<ParityGroupViewModel> parityGroups =
      <ParityGroupViewModel>[].obs;

  // Arama ve filtreleme
  final RxString searchQuery = ''.obs;

  // Sıralama
  final RxString sortField = 'orderIndex'.obs;
  final RxBool sortAscending = true.obs;

  // Sayfalama
  final RxInt currentPage = 0.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalItems = 0.obs;

  // Filtrelenmiş ve sıralanmış gruplar
  List<ParityGroupViewModel> get filteredGroups {
    var filtered = List<ParityGroupViewModel>.from(parityGroups);

    // Arama filtresi
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((group) =>
              group.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              group.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sıralama
    filtered.sort((a, b) {
      var comparison = 0;
      switch (sortField.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'description':
          comparison = a.description.compareTo(b.description);
          break;
        case 'orderIndex':
          comparison = a.orderIndex.compareTo(b.orderIndex);
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });

    // Toplam öğe sayısını güncelle
    totalItems.value = filtered.length;

    return filtered;
  }

  // Sayfalanmış gruplar
  List<ParityGroupViewModel> get paginatedGroups {
    final start = currentPage.value * pageSize.value;
    final end = (start + pageSize.value).clamp(0, filteredGroups.length);
    return filteredGroups.sublist(start, end);
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

  @override
  void onInit() {
    super.onInit();
    fetchParityGroups();
  }

  // Yeni sıra numarası alma
  int getNextOrderIndex() {
    if (parityGroups.isEmpty) return 1;
    return parityGroups
            .map((g) => g.orderIndex)
            .reduce((max, index) => index > max ? index : max) +
        1;
  }

  Future<void> fetchParityGroups() async {
    isLoading.value = true;
    try {
      final response = await _parityGroupService.getParityGroups();
      if (response.success) {
        parityGroups.assignAll(response.data ?? []);
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite grupları yüklenirken bir hata oluştu');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createParityGroup(
    String name,
    String description,
    bool isEnabled,
    int orderIndex,
  ) async {
    try {
      var createModel = ParityGroupCreateModel(
        name: name,
        description: description,
        orderIndex: orderIndex,
        isEnabled: isEnabled,
      );

      final response = await _parityGroupService.createParityGroup(
        parityGroupCreateModel: createModel,
      );

      if (response.success) {
        await fetchParityGroups();
        Get.snackbar('Başarılı', 'Parite grubu başarıyla eklendi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite grubu eklenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite grubu eklenirken bir hata oluştu');
    }
  }

  Future<void> updateParityGroup(
    int id,
    String name,
    String description,
    bool isEnabled,
    int orderIndex,
  ) async {
    try {
      var updateModel = ParityGroupUpdateModel(
        name: name,
        description: description,
        orderIndex: orderIndex,
        isEnabled: isEnabled,
      );

      final response = await _parityGroupService.updateParityGroup(
        id: id,
        parityGroupUpdateModel: updateModel,
      );

      if (response.success) {
        await fetchParityGroups();
        Get.snackbar('Başarılı', 'Parite grubu başarıyla güncellendi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite grubu güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite grubu güncellenirken bir hata oluştu');
    }
  }

  Future<void> deleteParityGroup(int id) async {
    try {
      final response = await _parityGroupService.deletePurityGroup(id);

      if (response.success) {
        await fetchParityGroups();
        Get.snackbar('Başarılı', 'Parite grubu başarıyla silindi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Parite grubu silinirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Parite grubu silinirken bir hata oluştu');
    }
  }

  Future<void> toggleParityGroupStatus(int id, bool isEnabled) async {
    try {
      final response =
          await _parityGroupService.updateParityGroupStatus(id, isEnabled);

      if (response.success) {
        await fetchParityGroups();
      } else {
        Get.snackbar(
            'Hata',
            response.message ??
                'Parite grubu durumu güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar(
          'Hata', 'Parite grubu durumu güncellenirken bir hata oluştu');
    }
  }
}
