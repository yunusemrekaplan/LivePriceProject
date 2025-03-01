import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/modules/auth/models/login_request.dart';

class AuthService extends GetxService {
  final _apiClient = Get.find<ApiClient>();
  final GetStorage _storage = GetStorage();

  Future<ApiResponse> login(LoginRequest loginRequest) async {
    final response = await _apiClient.post(
      ApiConfig.login,
      data: loginRequest.toJson(),
    );

    if (response.success && response.data != null) {
      await _storage.write('access_token', response.data['accessToken']);
      await _storage.write('refresh_token', response.data['refreshToken']);
      await _storage.write('user_id', response.data['id']);
      await _storage.write('username', response.data['userName']);
    }

    return response;
  }

  Future<void> logout() async {
    final refreshToken = _storage.read('refresh_token');
    if (refreshToken != null) {
      await _apiClient.post(ApiConfig.logout, data: refreshToken);
    }
    await _storage.erase();
  }
}
