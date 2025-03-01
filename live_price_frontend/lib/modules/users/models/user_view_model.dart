import 'package:live_price_frontend/core/models/base_auditable_dto.dart';

import 'user_role.dart';

class UserViewModel extends BaseAuditableDto {
  final String username;
  final String email;
  final String name;
  final String surname;
  final UserRole role;
  final int? customerId;
  final String? customerName;

  UserViewModel({
    required super.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.customerId,
    this.customerName,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) {
    return UserViewModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      role: UserRole.fromId(json['role']),
      customerId: json['customerId'],
      customerName: json['customerName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}
