import 'package:get/get.dart';
import 'package:live_price_frontend/core/config/api_config.dart';
import 'package:live_price_frontend/core/models/response_model.dart';
import 'package:live_price_frontend/core/services/api_client.dart';
import 'package:live_price_frontend/modules/customers/models/customer_create_model.dart';
import 'package:live_price_frontend/modules/customers/models/customer_update_model.dart';
import 'package:live_price_frontend/modules/customers/models/customer_view_model.dart';

class CustomerService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<ApiResponse> getCustomers() async {
    final response = await _apiClient.get(
      ApiConfig.customers,
      fromJsonList: (json) =>
          (json).map((item) => CustomerViewModel.fromJson(item)).toList(),
    );
    return response;
  }

  Future<ApiResponse> getCustomer(int id) async {
    final response = await _apiClient.get(
      '${ApiConfig.customers}/$id',
      fromJson: (json) => CustomerViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> createCustomer({
    required CustomerCreateModel customerCreateModel,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.customers,
      data: customerCreateModel.toJson(),
      fromJson: (json) => CustomerViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> updateCustomer({
    required int id,
    required CustomerUpdateModel customerUpdateModel,
  }) async {
    final response = await _apiClient.put(
      '${ApiConfig.customers}/$id',
      data: customerUpdateModel.toJson(),
      //fromJson: (json) => CustomerViewModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> deleteCustomer(int id) async {
    final response = await _apiClient.delete(
      '${ApiConfig.customers}/$id',
    );
    return response;
  }
}
