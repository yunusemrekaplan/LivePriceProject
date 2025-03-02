import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;

  late final Dio _dio;
  late final TokenManager _tokenManager;

  TokenService._internal() {
    _dio = Get.find<Dio>();
    _tokenManager = TokenManager();
  }

  String? getAuthorizationHeader() {
    final token = _tokenManager.getAccessToken();
    return token != null ? 'Bearer $token' : null;
  }

  Future<bool> refreshTokenIfNeeded() async {
    try {
      await _refreshToken();
      return true;
    } catch (e) {
      _tokenManager.clearTokens();
      return false;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = _tokenManager.getRefreshToken();
    if (refreshToken == null) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Refresh token not found',
      );
    }

    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await _tokenManager.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Failed to refresh token',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Failed to refresh token',
      );
    }
  }
}
