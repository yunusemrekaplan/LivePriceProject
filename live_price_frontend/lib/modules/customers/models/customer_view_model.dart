import 'package:live_price_frontend/core/models/base_auditable_dto.dart';
import 'package:live_price_frontend/modules/users/models/user_view_model.dart';

class CustomerViewModel extends BaseAuditableDto {
  final String name;
  final String? apiKey;
  final List<UserViewModel>? users;

  CustomerViewModel({
    required super.id,
    required this.name,
    this.apiKey,
    this.users,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory CustomerViewModel.fromJson(Map<String, dynamic> json) {
    return CustomerViewModel(
      id: json['id'],
      name: json['name'],
      apiKey: json['apiKey'],
      users: json['users'] != null
          ? List<UserViewModel>.from(json['users'].map((x) => UserViewModel.fromJson(x)))
          : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}
