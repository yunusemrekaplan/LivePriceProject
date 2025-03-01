import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';
import 'package:live_price_frontend/modules/customers/models/customer_model.dart';
import 'package:live_price_frontend/modules/customers/widgets/customer_form.dart';

class CustomersController extends GetxController {
  final customers = <CustomerModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.get('/customers');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        customers.value =
            data.map((json) => CustomerModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Müşteriler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCustomer(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.post('/customers', data: data);

      if (response.statusCode == 201) {
        await fetchCustomers();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Müşteri başarıyla oluşturuldu',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Müşteri oluşturulurken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCustomer(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response =
          await ApiService.instance.put('/customers/$id', data: data);

      if (response.statusCode == 200) {
        await fetchCustomers();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Müşteri başarıyla güncellendi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Müşteri güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.delete('/customers/$id');

      if (response.statusCode == 200) {
        await fetchCustomers();
        Get.snackbar(
          'Başarılı',
          'Müşteri başarıyla silindi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Müşteri silinirken bir hata oluştu',
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
          child: CustomerForm(
            onSubmit: createCustomer,
          ),
        ),
      ),
    );
  }

  void showEditDialog(CustomerModel customer) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: CustomerForm(
            customer: customer,
            onSubmit: (data) => updateCustomer(customer.id, data),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(CustomerModel customer) {
    Get.dialog(
      AlertDialog(
        title: const Text('Müşteriyi Sil'),
        content: Text(
            '${customer.name} müşterisini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteCustomer(customer.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
