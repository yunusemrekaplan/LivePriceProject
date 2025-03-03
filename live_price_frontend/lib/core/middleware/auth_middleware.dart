import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/services/token_service.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    final tokenManager = TokenManager();

    if (tokenManager.getAccessToken() == null) {
      log('Access token not found');
      return const RouteSettings(name: Routes.login);
    }

    if (!tokenManager.hasValidAccessToken()) {
      TokenService().refreshTokenIfNeeded().then((success) {
        if (!success) {
          log('Failed to refresh token 1');
          Get.offAllNamed(Routes.login);
        }
      }).catchError((error) {
        log('Failed to refresh token  2');
        Get.offAllNamed(Routes.login);
      });
    }

    return null;
  }

}
