import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/services/token_service.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    final tokenManager = TokenManager();

    if (tokenManager.getAccessToken() == null) {
      return const RouteSettings(name: '/login');
    }

    if (!tokenManager.hasValidAccessToken()) {
      TokenService().refreshTokenIfNeeded().then((success) {
        if (!success) {
          log('Failed to refresh token');
          Get.offAllNamed('/login');
        }
      }).catchError((error) {
        log('Failed to refresh token');
        Get.offAllNamed('/login');
      });
    }

    return null;
  }

}
