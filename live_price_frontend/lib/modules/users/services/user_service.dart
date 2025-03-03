import 'package:get/get.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/modules/users/models/user_create_model.dart';
import 'package:live_price_frontend/modules/users/models/user_update_model.dart';
import 'package:live_price_frontend/modules/users/models/user_view_model.dart';

class UserService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ApiResponse<List<UserViewModel>>> getUsers() async {
    final response = await _apiClient.get<List<UserViewModel>>(
      ApiConfig.users,
      fromJsonList: (json) =>
          (json).map((item) => UserViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse<UserViewModel>> getUser(int id) async {
    final response = await _apiClient.get<UserViewModel>(
      '${ApiConfig.users}/$id',
      fromJson: (json) => UserViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<List<UserViewModel>>> getUsersByCustomerId(
      int customerId) async {
    final response = await _apiClient.get<List<UserViewModel>>(
      '${ApiConfig.users}/by-customer/$customerId',
      fromJsonList: (json) =>
          (json).map((item) => UserViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse<UserViewModel>> createUser({
    required UserCreateModel userCreateModel,
  }) async {
    final response = await _apiClient.post<UserViewModel>(
      ApiConfig.users,
      data: userCreateModel.toJson(),
      fromJson: (json) => UserViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<UserViewModel>> updateUser({
    required int id,
    required UserUpdateModel userUpdateModel,
  }) async {
    final response = await _apiClient.put<UserViewModel>(
      '${ApiConfig.users}/$id',
      data: userUpdateModel.toJson(),
      fromJson: (json) => UserViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> deleteUser(int id) async {
    final response = await _apiClient.delete(
      '${ApiConfig.users}/$id',
    );
    return response;
  }
}
