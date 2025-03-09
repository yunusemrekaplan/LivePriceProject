import 'package:live_price_frontend/modules/customer_panel/models/c_parity_rule_view_model.dart';

class CParityViewModel {
  final int id;
  final String name;
  final String symbol;
  final bool isVisible;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;
  final int parityGroupId;

  CParityViewModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isVisible,
    this.spreadRuleType,
    this.spreadForAsk,
    this.spreadForBid,
    required this.parityGroupId,
  });


  factory CParityViewModel.fromJson(Map<String, dynamic> json) {
    SpreadRuleType? spreadRuleType;
    if (json['spreadRuleType'] != null) {
      spreadRuleType = SpreadRuleType.fromId(json['spreadRuleType']);
    }

    return CParityViewModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      isVisible: json['isVisible'],
      spreadRuleType: spreadRuleType,
      spreadForAsk: json['spreadForAsk']?.toDouble(),
      spreadForBid: json['spreadForBid']?.toDouble(),
      parityGroupId: json['parityGroupId'],
    );
  }
}