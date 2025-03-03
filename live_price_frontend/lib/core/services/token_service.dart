import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'token_manager.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();

  factory TokenService() => _instance;

  late final Dio _dio;
  final TokenManager _tokenManager = TokenManager();
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  TokenService._internal() {
    _dio = Get.find<Dio>();
  }

  Future<bool> refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return _tokenManager.hasValidAccessToken();
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      await _refreshToken();
      _refreshCompleter?.complete();
      return true;
    } catch (e) {
      _tokenManager.clearTokens();
      _refreshCompleter?.completeError(e);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
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
      final response = await _dio.post('/auth/refresh', data: jsonEncode(refreshToken));

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
          error: 'Failed to refresh token 3',
        );
      }
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Failed to refresh token 4',
      );
    }
  }
}
