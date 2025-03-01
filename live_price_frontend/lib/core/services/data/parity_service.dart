import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';

class ParityService {
  static final ParityService instance = ParityService._internal();
  final ApiService _apiService = ApiService.instance;

  ParityService._internal();

  Future<List<ParityViewModel>> getAll() async {
    final response = await _apiService.get('/parities');
    final List<dynamic> data = response.data;
    return data.map((json) => ParityViewModel.fromJson(json)).toList();
  }

  Future<ParityViewModel> getById(int id) async {
    final response = await _apiService.get('/parities/$id');
    return ParityViewModel.fromJson(response.data);
  }

  Future<ParityViewModel> create(ParityCreateModel model) async {
    final response = await _apiService.post('/parities', data: model.toJson());
    return ParityViewModel.fromJson(response.data);
  }

  Future<ParityViewModel> update(int id, ParityUpdateModel model) async {
    final response =
        await _apiService.put('/parities/$id', data: model.toJson());
    return ParityViewModel.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('/parities/$id');
  }

  Future<void> updateStatus(int id, bool isEnabled) async {
    await _apiService
        .put('/parities/$id/status', data: {'isEnabled': isEnabled});
  }
}
