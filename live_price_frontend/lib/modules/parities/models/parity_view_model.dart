import 'package:live_price_frontend/core/models/base_models.dart';

class ParityViewModel extends BaseAuditableDto {
  final String name;
  final String symbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;

  ParityViewModel({
    required super.id,
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory ParityViewModel.fromJson(Map<String, dynamic> json) {
    return ParityViewModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      parityGroupId: json['parityGroupId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}
