import 'package:get/get.dart';
import '../../../core/config/api_config.dart';
import '../../../core/models/response_model.dart';
import '../../../core/services/api_client.dart';
import '../models/parity_group_view_model.dart';
import '../models/parity_group_create_model.dart';
import '../models/parity_group_update_model.dart';

class ParityGroupService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ApiResponse<List<ParityGroupViewModel>>> getParityGroups() async {
    final response = await _apiClient.get<List<ParityGroupViewModel>>(
      ApiConfig.parityGroups,
      fromJsonList: (json) =>
          (json).map((item) => ParityGroupViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse> createParityGroup({
    required ParityGroupCreateModel parityGroupCreateModel,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.parityGroups,
      data: parityGroupCreateModel.toJson(),
    );
    return response;
  }

  Future<ApiResponse> updateParityGroup({
    required int id,
    required ParityGroupUpdateModel parityGroupUpdateModel,
  }) async {
    final response = await _apiClient.put(
      '${ApiConfig.parityGroups}/$id',
      data: parityGroupUpdateModel.toJson(),
    );
    return response;
  }

  Future<ApiResponse> updateParityGroupStatus(int id, bool isEnabled) async {
    final response = await _apiClient.patch(
      '${ApiConfig.parityGroups}/$id/status',
      data: isEnabled,
    );
    return response;
  }

  Future<ApiResponse> deletePurityGroup(int id) async {
    final response = await _apiClient.delete(
      '${ApiConfig.parityGroups}/$id',
    );
    return response;
  }
}
