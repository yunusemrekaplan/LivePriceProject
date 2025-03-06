import 'package:live_price_frontend/core/models/base_auditable_dto.dart';
import 'package:live_price_frontend/modules/parities/models/spread_rule_type.dart';

class ParityViewModel extends BaseAuditableDto {
  final String name;
  final String symbol;
  final String rawSymbol;
  final bool isEnabled;
  final int orderIndex;
  final int scale;
  final int parityGroupId;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;

  ParityViewModel({
    required super.id,
    required this.name,
    required this.symbol,
    required this.rawSymbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.scale,
    required this.spreadRuleType,
    required this.spreadForAsk,
    required this.spreadForBid,
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
      rawSymbol: json['rawSymbol'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      scale: json['scale'],
      spreadRuleType: json['spreadRuleType'] != null
          ? SpreadRuleType.fromId(json['spreadRuleType'])
          : null,
      spreadForAsk: json['spreadForAsk'],
      spreadForBid: json['spreadForBid'],
      parityGroupId: json['parityGroupId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }
}
