import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';
import 'package:live_price_frontend/modules/parities/models/parity_model.dart';
import 'package:live_price_frontend/modules/parities/widgets/parity_form.dart';

class ParitiesController extends GetxController {
  final parities = <ParityModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchParities();
  }

  Future<void> fetchParities() async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.get('/parities');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        parities.value =
            data.map((json) => ParityModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Pariteler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createParity(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.post('/parities', data: data);

      if (response.statusCode == 201) {
        await fetchParities();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Parite başarıyla oluşturuldu',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite oluşturulurken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateParity(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response =
          await ApiService.instance.put('/parities/$id', data: data);

      if (response.statusCode == 200) {
        await fetchParities();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Parite başarıyla güncellendi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteParity(int id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.delete('/parities/$id');

      if (response.statusCode == 200) {
        await fetchParities();
        Get.snackbar(
          'Başarılı',
          'Parite başarıyla silindi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite silinirken bir hata oluştu',
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
          child: ParityForm(
            onSubmit: createParity,
          ),
        ),
      ),
    );
  }

  void showEditDialog(ParityModel parity) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: ParityForm(
            parity: parity,
            onSubmit: (data) => updateParity(parity.id, data),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(ParityModel parity) {
    Get.dialog(
      AlertDialog(
        title: const Text('Pariteyi Sil'),
        content:
            Text('${parity.name} paritesini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteParity(parity.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
