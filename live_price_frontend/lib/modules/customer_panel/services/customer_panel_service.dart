import 'package:get/get.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_create_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_update_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_create_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_rule_update_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_view_model.dart';
import 'package:live_price_frontend/modules/customer_panel/models/c_parity_group_view_model.dart';

class CustomerPanelService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Müşteri Pariteleri
  Future<ApiResponse> getCustomerParities() async {
    final response = await _apiClient.get(
      ApiConfig.parities,
      fromJsonList: (json) => (json).map((item) => CParityViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  // Müşteri Parite Grupları
  Future<ApiResponse> getCustomerParityGroups() async {
    final response = await _apiClient.get(
      ApiConfig.parityGroups,
      fromJsonList: (json) => (json).map((item) => CParityGroupViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  // Parity Rules
  Future<ApiResponse> getParityRulesByCustomerId(int customerId) async {
    final response = await _apiClient.get(
      '/customer/parity-rules/by-customer/$customerId',
      fromJsonList: (json) => (json).map((item) => CParityRuleViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse<CParityRuleViewModel>> createParityRule({
    required CParityRuleCreateModel model,
  }) async {
    final response = await _apiClient.post(
      '/customer/parity-rules',
      data: model.toJson(),
      fromJson: (json) => CParityRuleViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<CParityRuleViewModel>> updateParityRule({
    required int id,
    required CParityRuleUpdateModel model,
  }) async {
    final response = await _apiClient.put(
      '/customer/parity-rules/$id',
      data: model.toJson(),
      fromJson: (json) => CParityRuleViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> deleteParityRule(int id) async {
    final response = await _apiClient.delete(
      '/customer/parity-rules/$id',
    );
    return response;
  }

  // Parity Group Rules
  Future<ApiResponse> getParityGroupRulesByCustomerId(int customerId) async {
    final response = await _apiClient.get(
      '/customer/parity-group-rules/by-customer/$customerId',
      fromJsonList: (json) =>
          (json).map((item) => CParityGroupRuleViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse<CParityGroupRuleViewModel>> createParityGroupRule({
    required CParityGroupRuleCreateModel model,
  }) async {
    final response = await _apiClient.post(
      '/customer/parity-group-rules',
      data: model.toJson(),
      fromJson: (json) => CParityGroupRuleViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<CParityGroupRuleViewModel>> updateParityGroupRule({
    required int id,
    required CParityGroupRuleUpdateModel model,
  }) async {
    final response = await _apiClient.put(
      '/customer/parity-group-rules/$id',
      data: model.toJson(),
      fromJson: (json) => CParityGroupRuleViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> deleteParityGroupRule(int id) async {
    final response = await _apiClient.delete(
      '/customer/parity-group-rules/$id',
    );
    return response;
  }
}
