import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';
import 'package:live_price_frontend/core/services/token_service.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  final ApiService _apiService = ApiService.instance;
  final TokenService _tokenService = TokenService.instance;

  AuthService._internal();

  Future<LoginResponse> login(LoginRequest request) async {
    final response =
        await _apiService.post('/auth/login', data: request.toJson());
    final loginResponse = LoginResponse.fromJson(response.data);
    await _tokenService.setToken(loginResponse);
    return loginResponse;
  }

  Future<void> register(RegisterRequest request) async {
    await _apiService.post('/auth/register', data: request.toJson());
  }

  Future<RefreshResponse> refresh(RefreshRequest request) async {
    final response =
        await _apiService.post('/auth/refresh', data: request.toJson());
    final refreshResponse = RefreshResponse.fromJson(response.data);

    final currentToken = _tokenService.currentToken;
    if (currentToken != null) {
      await _tokenService.setToken(LoginResponse(
        id: currentToken.id,
        userName: currentToken.userName,
        accessToken: refreshResponse.accessToken,
        refreshToken: refreshResponse.refreshToken,
      ));
    }

    return refreshResponse;
  }

  Future<void> logout() async {
    await _apiService.post('/auth/logout');
    await _tokenService.removeToken();
  }

  Future<bool> checkAuth() async {
    try {
      if (!_tokenService.hasToken || _tokenService.isTokenExpired) {
        return false;
      }

      final response = await _apiService.get('/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
