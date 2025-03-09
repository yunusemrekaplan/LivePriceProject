import 'c_parity_rule_view_model.dart';

class CParityRuleUpdateModel {
  final bool isVisible;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;

  CParityRuleUpdateModel({
    required this.isVisible,
    this.spreadRuleType,
    this.spreadForAsk,
    this.spreadForBid,
  });

  Map<String, dynamic> toJson() {
    return {
      'isVisible': isVisible,
      'spreadRuleType': spreadRuleType?.id,
      'spreadForAsk': spreadForAsk,
      'spreadForBid': spreadForBid,
    };
  }
}
