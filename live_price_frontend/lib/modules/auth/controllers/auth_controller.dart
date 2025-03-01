import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/api_service.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await ApiService.instance.post(
        '/auth/login',
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['accessToken'];
        ApiService.instance.setToken(token);
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Giriş yapılırken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
