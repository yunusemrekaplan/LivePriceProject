import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';

class CustomerPriceRuleService {
  static final CustomerPriceRuleService instance =
      CustomerPriceRuleService._internal();
  final ApiService _apiService = ApiService.instance;

  CustomerPriceRuleService._internal();

  Future<List<CustomerPriceRuleViewModel>> getAll() async {
    final response = await _apiService.get('/customer-price-rules');
    final List<dynamic> data = response.data;
    return data
        .map((json) => CustomerPriceRuleViewModel.fromJson(json))
        .toList();
  }

  Future<CustomerPriceRuleViewModel> getById(int id) async {
    final response = await _apiService.get('/customer-price-rules/$id');
    return CustomerPriceRuleViewModel.fromJson(response.data);
  }

  Future<CustomerPriceRuleViewModel> create(
      CustomerPriceRuleCreateModel model) async {
    final response =
        await _apiService.post('/customer-price-rules', data: model.toJson());
    return CustomerPriceRuleViewModel.fromJson(response.data);
  }

  Future<CustomerPriceRuleViewModel> update(
      int id, CustomerPriceRuleUpdateModel model) async {
    final response = await _apiService.put('/customer-price-rules/$id',
        data: model.toJson());
    return CustomerPriceRuleViewModel.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('/customer-price-rules/$id');
  }

  Future<void> updateStatus(int id, bool isEnabled) async {
    await _apiService.put('/customer-price-rules/$id/status',
        data: {'isEnabled': isEnabled});
  }

  Future<List<CustomerPriceRuleViewModel>> getByCustomerId(
      int customerId) async {
    final response =
        await _apiService.get('/customer-price-rules/by-customer/$customerId');
    final List<dynamic> data = response.data;
    return data
        .map((json) => CustomerPriceRuleViewModel.fromJson(json))
        .toList();
  }

  Future<List<CustomerPriceRuleViewModel>> getByParityId(int parityId) async {
    final response =
        await _apiService.get('/customer-price-rules/by-parity/$parityId');
    final List<dynamic> data = response.data;
    return data
        .map((json) => CustomerPriceRuleViewModel.fromJson(json))
        .toList();
  }
}
