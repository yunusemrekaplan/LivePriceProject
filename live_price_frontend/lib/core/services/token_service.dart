import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:live_price_frontend/core/models/models.dart';

class TokenService {
  static final TokenService instance = TokenService._internal();
  final GetStorage _storage = GetStorage();

  static const String _tokenKey = 'token';

  TokenService._internal();

  LoginResponse? get currentToken {
    final tokenJson = _storage.read(_tokenKey);
    if (tokenJson == null) return null;
    return LoginResponse.fromJson(tokenJson);
  }

  String? get accessToken => currentToken?.accessToken;
  String? get refreshToken => currentToken?.refreshToken;
  int? get userId => currentToken?.id;
  String? get userName => currentToken?.userName;

  Future<void> setToken(LoginResponse token) async {
    await _storage.write(_tokenKey, token.toJson());
  }

  Future<void> removeToken() async {
    await _storage.remove(_tokenKey);
  }

  bool get hasToken => currentToken != null;

  bool get isTokenExpired {
    final token = accessToken;
    if (token == null) return true;

    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  Map<String, dynamic>? getTokenClaims() {
    final token = accessToken;
    if (token == null) return null;

    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }
}
