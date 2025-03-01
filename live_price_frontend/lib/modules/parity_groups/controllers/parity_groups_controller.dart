import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';
import 'package:live_price_frontend/modules/parity_groups/models/parity_group_model.dart';
import 'package:live_price_frontend/modules/parity_groups/widgets/parity_group_form.dart';

class ParityGroupsController extends GetxController {
  final parityGroups = <ParityGroupModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchParityGroups();
  }

  Future<void> fetchParityGroups() async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.get('/parity-groups');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        parityGroups.value =
            data.map((json) => ParityGroupModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite grupları yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createParityGroup(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response =
          await ApiService.instance.post('/parity-groups', data: data);

      if (response.statusCode == 201) {
        await fetchParityGroups();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Parite grubu başarıyla oluşturuldu',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite grubu oluşturulurken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateParityGroup(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response =
          await ApiService.instance.put('/parity-groups/$id', data: data);

      if (response.statusCode == 200) {
        await fetchParityGroups();
        Get.back();
        Get.snackbar(
          'Başarılı',
          'Parite grubu başarıyla güncellendi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite grubu güncellenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteParityGroup(int id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.instance.delete('/parity-groups/$id');

      if (response.statusCode == 200) {
        await fetchParityGroups();
        Get.snackbar(
          'Başarılı',
          'Parite grubu başarıyla silindi',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Parite grubu silinirken bir hata oluştu',
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
          child: ParityGroupForm(
            onSubmit: createParityGroup,
          ),
        ),
      ),
    );
  }

  void showEditDialog(ParityGroupModel parityGroup) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          child: ParityGroupForm(
            parityGroup: parityGroup,
            onSubmit: (data) => updateParityGroup(parityGroup.id, data),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(ParityGroupModel parityGroup) {
    Get.dialog(
      AlertDialog(
        title: const Text('Parite Grubunu Sil'),
        content: Text(
            '${parityGroup.name} grubunu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteParityGroup(parityGroup.id);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
