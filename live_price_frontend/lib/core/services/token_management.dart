import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManagement {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';

  // Singleton instance
  static TokenManagement? _instance;
  final _storage = GetStorage();

  // Private constructor
  TokenManagement._();

  // Singleton factory constructor
  factory TokenManagement() {
    _instance ??= TokenManagement._();
    return _instance!;
  }

  // Access Token işlemleri
  String? getAccessToken() {
    return _storage.read<String>(accessTokenKey);
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(accessTokenKey, token);
  }

  bool hasValidAccessToken() {
    final token = getAccessToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  // Refresh Token işlemleri
  String? getRefreshToken() {
    return _storage.read<String>(refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(refreshTokenKey, token);
  }

  bool isExistRefreshToken() {
    final token = getRefreshToken();
    if (token == null) return false;
    return true;
  }

  // Token claims işlemleri
  Map<String, dynamic>? getAccessTokenClaims() {
    final token = getAccessToken();
    if (token == null) return null;
    return JwtDecoder.decode(token);
  }

  // Kullanıcı oturum işlemleri
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await setAccessToken(accessToken);
    await setRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.remove(accessTokenKey);
    await _storage.remove(refreshTokenKey);
  }

  bool isAuthenticated() {
    return hasValidAccessToken();
  }
}
