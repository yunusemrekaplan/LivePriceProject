import 'package:live_price_frontend/modules/parities/models/spread_rule_type.dart';

class ParityUpdateModel {
  final String? name;
  final String? symbol;
  final String? rawSymbol;
  final bool? isEnabled;
  final int? orderIndex;
  final int? scale;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;
  final int? parityGroupId;

  ParityUpdateModel({
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
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (rawSymbol != null) 'rawSymbol': rawSymbol,
      if (isEnabled != null) 'isEnabled': isEnabled,
      if (orderIndex != null) 'orderIndex': orderIndex,
      if (scale != null) 'scale': scale,
      if (spreadRuleType != null) 'spreadRuleType': spreadRuleType!.id,
      if (spreadForAsk != null) 'spreadForAsk': spreadForAsk,
      if (spreadForBid != null) 'spreadForBid': spreadForBid,
      if (parityGroupId != null) 'parityGroupId': parityGroupId,
    };
  }
}