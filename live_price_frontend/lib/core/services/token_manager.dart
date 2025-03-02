import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userNameKey = 'userName';

  // Singleton instance
  static TokenManager? _instance;
  final _storage = GetStorage();

  // Private constructor
  TokenManager._();

  // Singleton factory constructor
  factory TokenManager() {
    _instance ??= TokenManager._();
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

  Future<void> setUserName(String userName) async {
    await _storage.write(userNameKey, userName);
  }

  String? getUserName() {
    return _storage.read<String>(userNameKey);
  }

  // Kullanıcı oturum işlemleri
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userName,
  }) async {
    await setAccessToken(accessToken);
    await setRefreshToken(refreshToken);
    await setUserName(userName);
  }

  Future<void> clearTokens() async {
    await _storage.remove(accessTokenKey);
    await _storage.remove(refreshTokenKey);
    await _storage.remove(userNameKey);
  }

  bool isAuthenticated() {
    return hasValidAccessToken();
  }
}
