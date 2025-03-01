import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';

class CustomerService {
  static final CustomerService instance = CustomerService._internal();
  final ApiService _apiService = ApiService.instance;

  CustomerService._internal();

  Future<List<CustomerViewModel>> getAll() async {
    final response = await _apiService.get('/customers');
    final List<dynamic> data = response.data;
    return data.map((json) => CustomerViewModel.fromJson(json)).toList();
  }

  Future<CustomerViewModel> getById(int id) async {
    final response = await _apiService.get('/customers/$id');
    return CustomerViewModel.fromJson(response.data);
  }

  Future<CustomerViewModel> create(CustomerCreateModel model) async {
    final response = await _apiService.post('/customers', data: model.toJson());
    return CustomerViewModel.fromJson(response.data);
  }

  Future<CustomerViewModel> update(int id, CustomerUpdateModel model) async {
    final response =
        await _apiService.put('/customers/$id', data: model.toJson());
    return CustomerViewModel.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('/customers/$id');
  }

  /*Future<void> regenerateApiKey(int id) async {
    await _apiService.post('/customers/$id/regenerate-api-key');
  }*/
}
