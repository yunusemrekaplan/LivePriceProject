import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/api_service.dart';
import 'package:live_price_frontend/modules/users/models/user_model.dart';
import 'package:live_price_frontend/modules/users/widgets/user_form.dart';

class UsersController extends GetxController {
  final users = <UserModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        users.value = data.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kullanıcılar yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.post('/users', data: data);

      if (response.statusCode == 201) {
        await fetchUsers();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Kullanıcı başarıyla oluşturuldu',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kullanıcı oluşturulurken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.put('/users/$id', data: data);

      if (response.statusCode == 200) {
        await fetchUsers();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Kullanıcı başarıyla güncellendi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kullanıcı güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.delete('/users/$id');

      if (response.statusCode == 200) {
        await fetchUsers();
        Get.snackbar(
          'Başarılı',
          'Kullanıcı başarıyla silindi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Kullanıcı silinirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showCreateDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: UserForm(
            onSubmit: createUser,
          ),
        ),
      ),
    );
  }

  void showEditDialog(UserModel user) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: UserForm(
            user: user,
            onSubmit: (data) => updateUser(user.id, data),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Kullanıcıyı Sil'),
        content: Text(
            '${user.name} ${user.surname} kullanıcısını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteUser(user.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
