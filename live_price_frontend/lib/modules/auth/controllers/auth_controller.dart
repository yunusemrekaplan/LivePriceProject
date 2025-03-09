import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/modules/auth/services/auth_service.dart';
import 'package:live_price_frontend/modules/auth/models/login_request.dart';
import 'package:live_price_frontend/modules/users/models/user_role.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _tokenManager = TokenManager();
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> handleLogin() async {
    try {
      errorMessage.value = '';

      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final loginRequest = LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      final response = await _authService.login(loginRequest);

      if (response.success) {
        // Kullanıcı rolüne göre yönlendirme
        final userRole = _tokenManager.getUserRole();
        if (userRole == UserRole.customer.name) {
          // Müşteri rolü için müşteri dashboard'una yönlendir
          Get.offAllNamed(Routes.customerPanel);
        } else {
          // Admin rolü için admin dashboard'una yönlendir
          Get.offAllNamed(Routes.home);
        }
      } else {
        errorMessage.value = response.message ?? 'Giriş işlemi başarısız oldu';
      }
    } catch (e) {
      errorMessage.value = 'Bir hata oluştu. Lütfen tekrar deneyin.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleLogout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}
