import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/modules/users/models/user_role.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class LayoutMiddleware extends GetMiddleware {
  final TokenManager _tokenManager = TokenManager();

  @override
  RouteSettings? redirect(String? route) {
    // Giriş yapılmış mı kontrol et
    if (!_tokenManager.isAuthenticated()) {
      return null; // AuthMiddleware bununla ilgilenecek
    }

    final userRole = _tokenManager.getUserRole();

    // Müşteri rolü kontrolü
    if (userRole == UserRole.customer.name) {
      // Eğer anasayfaya erişmeye çalışıyorsa müşteri pariteler sayfasına yönlendir
      if (route == Routes.home) {
        return const RouteSettings(name: Routes.customerParities);
      }

      // Eğer eski müşteri paneline erişmeye çalışıyorsa, yeni sayfalara yönlendir
      if (route == Routes.customerPanel) {
        return const RouteSettings(name: Routes.customerParities);
      }

      // Eğer admin pariteler veya parite grupları sayfalarına erişmeye çalışıyorsa,
      // müşteri versiyonlarına yönlendir
      if (route == Routes.parities) {
        return const RouteSettings(name: Routes.customerParities);
      }

      if (route == Routes.parityGroups) {
        return const RouteSettings(name: Routes.customerParityGroups);
      }

      // Eğer müşterinin erişemeyeceği sayfalara erişmeye çalışıyorsa (sadece admin tarafındaki sayfalar)
      if (route == Routes.customers || route == Routes.users) {
        return const RouteSettings(name: Routes.customerParities);
      }
    }

    // Admin rolü kontrolü
    if (userRole == UserRole.admin.name) {
      // Admin'in müşteri sayfalarına erişmeye çalışması durumunda ana sayfaya yönlendir
      if (route == Routes.customerPanel ||
          route == Routes.customerParities ||
          route == Routes.customerParityGroups) {
        return const RouteSettings(name: Routes.home);
      }
    }

    return null; // Herhangi bir yönlendirme yapma
  }
}
