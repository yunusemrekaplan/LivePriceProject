import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_management.dart';

class TokenService {
  final _dio = Get.find<Dio>();
  final TokenManagement _tokenManagement;

  TokenService() : _tokenManagement = TokenManagement();

  String? getAuthorizationHeader() {
    final token = _tokenManagement.getAccessToken();
    return token != null ? 'Bearer $token' : null;
  }

  Future<bool> refreshTokenIfNeeded() async {
    try {
      await _refreshToken();
      return true;
    } catch (e) {
      _tokenManagement.clearTokens();
      return false;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = _tokenManagement.getRefreshToken();
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

        await _tokenManagement.saveTokens(
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
