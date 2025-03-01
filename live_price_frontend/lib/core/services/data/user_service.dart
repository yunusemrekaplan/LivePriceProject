import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';

class UserService {
  static final UserService instance = UserService._internal();
  final ApiService _apiService = ApiService.instance;

  UserService._internal();

  Future<List<UserViewModel>> getAll() async {
    final response = await _apiService.get('/users');
    final List<dynamic> data = response.data;
    return data.map((json) => UserViewModel.fromJson(json)).toList();
  }

  Future<UserViewModel> getById(int id) async {
    final response = await _apiService.get('/users/$id');
    return UserViewModel.fromJson(response.data);
  }

  Future<UserViewModel> create(UserCreateModel model) async {
    final response = await _apiService.post('/users', data: model.toJson());
    return UserViewModel.fromJson(response.data);
  }

  Future<UserViewModel> update(int id, UserUpdateModel model) async {
    final response = await _apiService.put('/users/$id', data: model.toJson());
    return UserViewModel.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('/users/$id');
  }

  Future<List<UserViewModel>> getByCustomerId(int customerId) async {
    final response = await _apiService.get('/users/by-customer/$customerId');
    final List<dynamic> data = response.data;
    return data.map((json) => UserViewModel.fromJson(json)).toList();
  }
}
