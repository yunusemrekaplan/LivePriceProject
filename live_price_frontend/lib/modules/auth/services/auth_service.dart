import 'package:get/get.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/core/services/token_manager.dart';
import 'package:live_price_frontend/modules/auth/models/login_request.dart';
import 'package:live_price_frontend/modules/auth/models/login_response.dart';

class AuthService extends GetxService {
  final _apiClient = Get.find<ApiClient>();
  final _tokenManager = TokenManager();

  Future<ApiResponse<LoginResponse>> login(LoginRequest loginRequest) async {
    final response = await _apiClient.post<LoginResponse>(
      ApiConfig.login,
      data: loginRequest.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    if (response.success && response.data != null) {
      await _tokenManager.setAccessToken(response.data!.accessToken);
      await _tokenManager.setRefreshToken(response.data!.refreshToken);
    }

    return response;
  }

  Future<void> logout() async {
    final refreshToken = _tokenManager.getRefreshToken();
    if (refreshToken != null) {
      await _apiClient.post(ApiConfig.logout, data: refreshToken);
    }
    await _tokenManager.clearTokens();
  }
}
