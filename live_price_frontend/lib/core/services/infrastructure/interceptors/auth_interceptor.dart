import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/token_service.dart';
import 'package:live_price_frontend/routes/app_pages.dart';

class AuthInterceptor extends dio.InterceptorsWrapper {
  final TokenService _tokenService;
  final dio.Dio _dio;

  AuthInterceptor(this._tokenService, this._dio);

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    final token = _tokenService.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
      dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (await _handleTokenRefresh()) {
        final retryResponse = await _retryRequest(err);
        if (retryResponse != null) {
          handler.resolve(retryResponse);
          return;
        }
      }
      await _handleLogout();
    }
    handler.next(err);
  }

  Future<bool> _handleTokenRefresh() async {
    try {
      final refreshToken = _tokenService.refreshToken;
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final refreshResponse = RefreshResponse.fromJson(response.data);
        final currentToken = _tokenService.currentToken;
        if (currentToken != null) {
          await _tokenService.setToken(LoginResponse(
            id: currentToken.id,
            userName: currentToken.userName,
            accessToken: refreshResponse.accessToken,
            refreshToken: refreshResponse.refreshToken,
          ));
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleLogout() async {
    await _tokenService.removeToken();
    Get.offAllNamed(Routes.login);
  }

  Future<dio.Response<dynamic>?> _retryRequest(dio.DioException error) async {
    try {
      final options = dio.Options(
        method: error.requestOptions.method,
        headers: error.requestOptions.headers,
      );

      final response = await _dio.request(
        error.requestOptions.path,
        options: options,
        data: error.requestOptions.data,
        queryParameters: error.requestOptions.queryParameters,
      );

      return response;
    } on dio.DioException {
      return null;
    }
  }
}
