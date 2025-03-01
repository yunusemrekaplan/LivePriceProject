import 'package:live_price_frontend/core/models/models.dart';
import 'package:live_price_frontend/core/services/infrastructure/api_service.dart';

class ParityGroupService {
  static final ParityGroupService instance = ParityGroupService._internal();
  final ApiService _apiService = ApiService.instance;

  ParityGroupService._internal();

  Future<List<ParityGroupViewModel>> getAll() async {
    final response = await _apiService.get('/parityGroups');
    final List<dynamic> data = response.data;
    return data.map((json) => ParityGroupViewModel.fromJson(json)).toList();
  }

  Future<ParityGroupViewModel> getById(int id) async {
    final response = await _apiService.get('/parityGroups/$id');
    return ParityGroupViewModel.fromJson(response.data);
  }

  Future<ParityGroupViewModel> create(ParityGroupCreateModel model) async {
    final response =
        await _apiService.post('/parityGroups', data: model.toJson());
    return ParityGroupViewModel.fromJson(response.data);
  }

  Future<ParityGroupViewModel> update(
      int id, ParityGroupUpdateModel model) async {
    final response =
        await _apiService.put('/parityGroups/$id', data: model.toJson());
    return ParityGroupViewModel.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('/parityGroups/$id');
  }
}
