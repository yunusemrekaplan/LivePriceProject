import 'package:live_price_frontend/core/models/base_auditable_dto.dart';

class CParityGroupRuleViewModel extends BaseAuditableDto {
  final int customerId;
  final int parityGroupId;
  final bool isVisible;

  CParityGroupRuleViewModel({
    required int id,
    required this.customerId,
    required this.parityGroupId,
    required this.isVisible,
    DateTime? createdAt,
    int? createdById,
    DateTime? updatedAt,
    int? updatedById,
  }) : super(
          id: id,
          createdAt: createdAt,
          createdById: createdById,
          updatedAt: updatedAt,
          updatedById: updatedById,
        );

  factory CParityGroupRuleViewModel.fromJson(Map<String, dynamic> json) {
    return CParityGroupRuleViewModel(
      id: json['id'],
      customerId: json['customerId'],
      parityGroupId: json['parityGroupId'],
      isVisible: json['isVisible'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'parityGroupId': parityGroupId,
      'isVisible': isVisible,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
