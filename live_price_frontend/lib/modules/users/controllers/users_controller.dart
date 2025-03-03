import 'package:get/get.dart';
import 'package:live_price_frontend/modules/customers/models/customer_view_model.dart';
import 'package:live_price_frontend/modules/customers/services/customer_service.dart';
import 'package:live_price_frontend/modules/users/models/user_create_model.dart';
import 'package:live_price_frontend/modules/users/models/user_role.dart';
import 'package:live_price_frontend/modules/users/models/user_update_model.dart';
import 'package:live_price_frontend/modules/users/models/user_view_model.dart';
import 'package:live_price_frontend/modules/users/services/user_service.dart';
import 'package:live_price_frontend/modules/users/widgets/user_dialogs.dart';

class UsersController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final CustomerService _customerService = Get.find<CustomerService>();

  final RxBool isLoading = false.obs;
  final RxList<UserViewModel> users = <UserViewModel>[].obs;
  final RxList<CustomerViewModel> customers = <CustomerViewModel>[].obs;

  // Arama ve filtreleme
  final RxString searchQuery = ''.obs;
  final RxInt selectedRoleFilter = RxInt(-1);
  final RxInt selectedCustomerFilter = RxInt(-1);

  // Sıralama
  final RxString sortField = 'name'.obs;
  final RxBool sortAscending = true.obs;

  // Sayfalama
  final RxInt currentPage = 0.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalItems = 0.obs;

  // Filtrelenmiş ve sıralanmış kullanıcılar
  List<UserViewModel> get filteredUsers {
    var filtered = List<UserViewModel>.from(users);

    // Arama filtresi
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((user) =>
              user.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              user.surname
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              user.username
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              user.email
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Rol filtresi
    if (selectedRoleFilter.value >= 0) {
      filtered = filtered
          .where((user) => user.role.id == selectedRoleFilter.value)
          .toList();
    }

    // Müşteri filtresi
    if (selectedCustomerFilter.value > 0) {
      filtered = filtered
          .where((user) => user.customerId == selectedCustomerFilter.value)
          .toList();
    }

    // Sıralama
    filtered.sort((a, b) {
      var comparison = 0;
      switch (sortField.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'surname':
          comparison = a.surname.compareTo(b.surname);
          break;
        case 'username':
          comparison = a.username.compareTo(b.username);
          break;
        case 'email':
          comparison = a.email.compareTo(b.email);
          break;
        case 'role':
          comparison = a.role.id.compareTo(b.role.id);
          break;
        case 'customer':
          final aCustomer = a.customerName ?? '';
          final bCustomer = b.customerName ?? '';
          comparison = aCustomer.compareTo(bCustomer);
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

  // Sayfalanmış kullanıcılar
  List<UserViewModel> get paginatedUsers {
    final start = currentPage.value * pageSize.value;
    final end = (start + pageSize.value).clamp(0, filteredUsers.length);
    return filteredUsers.sublist(start, end);
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

  // Rol filtresini güncelleme
  void updateRoleFilter(int roleId) {
    selectedRoleFilter.value = roleId;
    currentPage.value = 0; // İlk sayfaya dön
  }

  // Müşteri filtresini güncelleme
  void updateCustomerFilter(int customerId) {
    selectedCustomerFilter.value = customerId;
    currentPage.value = 0; // İlk sayfaya dön
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchCustomers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await _userService.getUsers();
      if (response.success) {
        users.assignAll(response.data ?? []);
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Kullanıcılar yüklenirken bir hata oluştu');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await _customerService.getCustomers();
      if (response.success) {
        customers.assignAll(response.data ?? []);
      }
    } catch (e) {
      Get.snackbar('Hata', 'Müşteriler yüklenirken bir hata oluştu');
    }
  }

  String getCustomerName(int? customerId) {
    if (customerId == null) return '';
    final customer = customers.firstWhereOrNull((c) => c.id == customerId);
    return customer?.name ?? 'Bilinmeyen Müşteri';
  }

  Future<void> createUser(
    String username,
    String password,
    String email,
    String name,
    String surname,
    UserRole role,
    int? customerId,
  ) async {
    try {
      var createModel = UserCreateModel(
        username: username,
        password: password,
        email: email,
        name: name,
        surname: surname,
        role: role,
        customerId: customerId,
      );
      final response =
          await _userService.createUser(userCreateModel: createModel);

      if (response.success) {
        await fetchUsers();
        Get.snackbar('Başarılı', 'Kullanıcı başarıyla eklendi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Kullanıcı eklenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı eklenirken bir hata oluştu');
    }
  }

  Future<void> updateUser(
    int id,
    String? username,
    String? password,
    String? email,
    String? name,
    String? surname,
    UserRole? role,
    int? customerId,
  ) async {
    try {
      var updateModel = UserUpdateModel(
        username: username,
        password: password,
        email: email,
        name: name,
        surname: surname,
        role: role,
        customerId: customerId,
      );

      final response =
          await _userService.updateUser(id: id, userUpdateModel: updateModel);

      if (response.success) {
        await fetchUsers();
        Get.snackbar('Başarılı', 'Kullanıcı başarıyla güncellendi');
      } else {
        Get.snackbar('Hata',
            response.message ?? 'Kullanıcı güncellenirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı güncellenirken bir hata oluştu');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _userService.deleteUser(id);

      if (response.success) {
        await fetchUsers();
        Get.snackbar('Başarılı', 'Kullanıcı başarıyla silindi');
      } else {
        Get.snackbar(
            'Hata', response.message ?? 'Kullanıcı silinirken bir hata oluştu');
      }
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı silinirken bir hata oluştu');
    }
  }

  void showAddEditDialog({UserViewModel? user}) {
    UserDialogs.showAddEditDialog(user: user, customers: customers);
  }

  void showDeleteDialog(UserViewModel user) {
    UserDialogs.showDeleteDialog(user);
  }
}
