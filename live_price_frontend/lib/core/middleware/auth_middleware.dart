import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_service.dart';

class AuthMiddleware extends GetMiddleware {
  final _tokenService = TokenService();

  @override
  RouteSettings? redirect(String? route) {
    final authHeader = _tokenService.getAuthorizationHeader();
    if (authHeader == null) {
      return const RouteSettings(name: '/login');
    }

    // Token kontrolünü arka planda yap
    _checkTokenValidity();
    return null;
  }

  Future<void> _checkTokenValidity() async {
    final isTokenValid = await _tokenService.refreshTokenIfNeeded();
    if (!isTokenValid) {
      Get.offAllNamed('/login');
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  // Sayfa geçişlerinde kullanılabilecek wrapper widget
  Widget authenticationWrapper({required Widget child}) {
    return FutureBuilder<bool>(
      future: checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return child;
        }

        // Burada null veya false durumunda login sayfasına yönlendirme yapılmış olacak
        return const SizedBox.shrink();
      },
    );
  }

  Future<bool> checkAuthentication() async {
    final authHeader = _tokenService.getAuthorizationHeader();

    if (authHeader == null) {
      // Token yoksa login sayfasına yönlendir
      Navigator.of(Get.context!).pushReplacementNamed('/login');
      return false;
    }

    // Token var ama geçerliliğini kontrol et
    final isTokenValid = await _tokenService.refreshTokenIfNeeded();
    if (!isTokenValid) {
      // Token yenilenemedi, login sayfasına yönlendir
      Navigator.of(Get.context!).pushReplacementNamed('/login');
      return false;
    }

    return true;
  }
}
