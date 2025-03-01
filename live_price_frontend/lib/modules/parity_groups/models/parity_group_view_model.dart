import 'package:live_price_frontend/core/models/base_models.dart';

class ParityGroupViewModel extends BaseAuditableDto {
  final String name;
  final String description;
  final bool isEnabled;
  final int orderIndex;

  ParityGroupViewModel({
    required super.id,
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.orderIndex,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory ParityGroupViewModel.fromJson(Map<String, dynamic> json) {
    return ParityGroupViewModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}