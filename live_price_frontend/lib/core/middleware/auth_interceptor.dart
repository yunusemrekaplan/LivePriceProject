import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/core/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final _dio = Get.find<Dio>();


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
    var tokenService = TokenService();

    if (err.response?.statusCode == 401) {
      tokenService.refreshTokenIfNeeded().then((success) async {
        if (success) {
          // Yeni token ile isteği tekrarla
          final authHeader = getAuthorizationHeader();
          if (authHeader != null) {
            err.requestOptions.headers['Authorization'] = authHeader;
            final response = await _dio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        }
        return handler.next(err);
      }).catchError((error) {
        return handler.next(err);
      });
    } else {
      return handler.next(err);
    }
  }
}
