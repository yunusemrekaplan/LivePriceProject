import 'package:live_price_frontend/modules/parities/models/spread_rule_type.dart';

class ParityCreateModel {
  final String name;
  final String symbol;
  final String rawSymbol;
  final bool isEnabled;
  final int orderIndex;
  final int scale;
  final SpreadRuleType spreadRuleType;
  final double spreadForAsk;
  final double spreadForBid;
  final int parityGroupId;

  ParityCreateModel({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'rawSymbol': rawSymbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'scale': scale,
      'spreadRuleType': spreadRuleType.id,
      'spreadForAsk': spreadForAsk,
      'spreadForBid': spreadForBid,
      'parityGroupId': parityGroupId,
    };
  }
}
