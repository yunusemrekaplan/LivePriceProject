import 'package:live_price_frontend/core/models/base_auditable_dto.dart';

enum SpreadRuleType {
  fixed(0, 'Sabit'),
  percentage(1, 'Yüzde');

  final int id;
  final String name;

  const SpreadRuleType(this.id, this.name);

  static SpreadRuleType fromId(int id) {
    return SpreadRuleType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Geçersiz spread kuralı tipi: $id'),
    );
  }
}

class CParityRuleViewModel extends BaseAuditableDto {
  final int customerId;
  final int parityId;
  final bool isVisible;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;

  CParityRuleViewModel({
    required int id,
    required this.customerId,
    required this.parityId,
    required this.isVisible,
    this.spreadRuleType,
    this.spreadForAsk,
    this.spreadForBid,
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

  factory CParityRuleViewModel.fromJson(Map<String, dynamic> json) {
    SpreadRuleType? spreadRuleType;
    if (json['spreadRuleType'] != null) {
      spreadRuleType = SpreadRuleType.fromId(json['spreadRuleType']);
    }

    return CParityRuleViewModel(
      id: json['id'],
      customerId: json['customerId'],
      parityId: json['parityId'],
      isVisible: json['isVisible'],
      spreadRuleType: spreadRuleType,
      spreadForAsk: json['spreadForAsk']?.toDouble(),
      spreadForBid: json['spreadForBid']?.toDouble(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}
