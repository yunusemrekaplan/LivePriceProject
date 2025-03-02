import 'dart:developer';

import 'package:get/get.dart';
import '../../../core/config/api_config.dart';
import '../../../core/models/response_model.dart';
import '../../../core/services/api_client.dart';
import '../models/parity_group_view_model.dart';

class ParityGroupsService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ApiResponse<List<ParityGroupViewModel>>> getParityGroups() async {
    final response = await _apiClient.get<List<ParityGroupViewModel>>(
      ApiConfig.parityGroups,
      fromJsonList: (json) => (json).map((item) => ParityGroupViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse> createParityGroup({
    required String name,
    required int orderIndex,
    bool isEnabled = true,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.parityGroups,
      data: {
        'name': name,
        'orderIndex': orderIndex,
        'isEnabled': isEnabled,
      },
    );
    return response;
  }

  Future<ApiResponse> updateParityGroup({
    required int id,
    String? name,
    int? orderIndex,
    bool? isEnabled,
  }) async {
    final response = await _apiClient.put(
      '${ApiConfig.parityGroups}/$id',
      data: {
        if (name != null) 'name': name,
        if (orderIndex != null) 'orderIndex': orderIndex,
        if (isEnabled != null) 'isEnabled': isEnabled,
      },
    );
    return response;
  }

  Future<ApiResponse> deleteParityGroup(int id) async {
    final response = await _apiClient.delete(
      '${ApiConfig.parityGroups}/$id',
    );
    return response;
  }
}
