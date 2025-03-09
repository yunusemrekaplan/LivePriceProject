import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/services/token_service.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class AuthInterceptor extends Interceptor {
  String? getAuthorizationHeader() {
    final token = TokenManager().getAccessToken();
    return token != null ? 'Bearer $token' : null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authHeader = getAuthorizationHeader();
    if (authHeader != null) {
      options.headers['Authorization'] = authHeader;
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final dio = Get.find<Dio>();
    var tokenService = TokenService();

    if (err.response?.statusCode == 401) {
      tokenService.refreshTokenIfNeeded().then((success) async {
        if (success) {
          // Yeni token ile isteği tekrarla
          final authHeader = getAuthorizationHeader();
          if (authHeader != null) {
            err.requestOptions.headers['Authorization'] = authHeader;
            final response = await dio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        }

        TokenManager().clearTokens();
        Get.offAllNamed(Routes.login);

        return handler.next(err);
      }).catchError((error) {
        TokenManager().clearTokens();
        Get.offAllNamed(Routes.login);

        return handler.next(err);
      });
    } else {
      return handler.next(err);
    }
  }
}
