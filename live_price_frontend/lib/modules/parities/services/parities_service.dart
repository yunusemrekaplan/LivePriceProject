import 'package:get/get.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/modules/parities/models/parity_create_model.dart';
import 'package:live_price_frontend/modules/parities/models/parity_update_model.dart';
import 'package:live_price_frontend/modules/parities/models/parity_view_model.dart';

class ParitiesService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ApiResponse<List<ParityViewModel>>> getParities() async {
    final response = await _apiClient.get<List<ParityViewModel>>(
      ApiConfig.parities,
      fromJsonList: (json) => (json).map((item) => ParityViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse<ParityViewModel>> createParity({
    required ParityCreateModel parityCreateModel,
  }) async {
    final response = await _apiClient.post<ParityViewModel>(
      ApiConfig.parities,
      data: parityCreateModel.toJson(),
      fromJson: (json) => ParityViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<ParityViewModel>> updateParity({
    required int id,
    required ParityUpdateModel parityUpdateModel,
  }) async {
    final response = await _apiClient.put<ParityViewModel>(
      '${ApiConfig.parities}/$id',
      data: parityUpdateModel.toJson(),
      fromJson: (json) => ParityViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> updateParityStatus(int id, bool isEnabled) async {
    final response = await _apiClient.patch(
      '${ApiConfig.parities}/$id/status',
      data: isEnabled,
    );
    return response;
  }

  Future<ApiResponse> deleteParity(int id) async {
    final response = await _apiClient.delete(
      '${ApiConfig.parities}/$id',
    );
    return response;
  }
}
