import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/models/customer_create_model.dart';
import 'package:live_price_frontend/modules/customers/models/customer_update_model.dart';
import 'package:live_price_frontend/modules/customers/models/customer_view_model.dart';
import 'package:live_price_frontend/modules/customers/services/customer_service.dart';
import 'package:live_price_frontend/modules/customers/widgets/customer_dialogs.dart';

class CustomersController extends GetxController {
  final CustomerService _customerService = Get.find<CustomerService>();

  final RxBool isLoading = false.obs;
  final RxList<CustomerViewModel> customers = <CustomerViewModel>[].obs;

  // Arama ve filtreleme
  final RxString searchQuery = ''.obs;

  // Sıralama
  final RxString sortField = 'name'.obs;
  final RxBool sortAscending = true.obs;

  // Sayfalama
  final RxInt currentPage = 0.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalItems = 0.obs;

  // Filtrelenmiş ve sıralanmış müşteriler
  List<CustomerViewModel> get filteredCustomers {
    var filtered = List<CustomerViewModel>.from(customers);

    // Arama filtresi
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((customer) => customer.name
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
        case 'id':
          comparison = a.id.compareTo(b.id);
          break;
        case 'createdAt':
          final aDate = a.createdAt ?? DateTime(1900);
          final bDate = b.createdAt ?? DateTime(1900);
          comparison = aDate.compareTo(bDate);
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });

    // Toplam öğe sayısını güncelle
    totalItems.value = filtered.length;

    return filtered;
  }

  // Sayfalanmış müşteriler
  List<CustomerViewModel> get paginatedCustomers {
    final start = currentPage.value * pageSize.value;
    final end = (start + pageSize.value).clamp(0, filteredCustomers.length);
    return filteredCustomers.sublist(start, end);
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
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    isLoading.value = true;
    try {
      final response = await _customerService.getCustomers();
      if (response.success) {
        customers.assignAll(response.data ?? []);
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Müşteriler yüklenirken bir hata oluştu');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCustomer(String name) async {
    try {
      var createModel = CustomerCreateModel(name: name);
      final response = await _customerService.createCustomer(
          customerCreateModel: createModel);

      if (response.success) {
        await fetchCustomers();
        Get.snackbar('Başarılı', 'Müşteri başarıyla eklendi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Müşteri eklenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Müşteri eklenirken bir hata oluştu');
    }
  }

  Future<void> updateCustomer(int id, String name) async {
    try {
      var updateModel = CustomerUpdateModel(name: name);
      final response = await _customerService.updateCustomer(
        id: id,
        customerUpdateModel: updateModel,
      );

      if (response.success) {
        await fetchCustomers();
        Get.snackbar('Başarılı', 'Müşteri başarıyla güncellendi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Müşteri güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Müşteri güncellenirken bir hata oluştu');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      final response = await _customerService.deleteCustomer(id);

      if (response.success) {
        await fetchCustomers();
        Get.snackbar('Başarılı', 'Müşteri başarıyla silindi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Müşteri silinirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Müşteri silinirken bir hata oluştu');
    }
  }

  void showAddEditDialog({CustomerViewModel? customer}) {
    CustomerDialogs.showAddEditDialog(customer: customer);
  }

  void showDeleteDialog(CustomerViewModel customer) {
    CustomerDialogs.showDeleteDialog(customer);
  }
}
