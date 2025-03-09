import 'c_parity_rule_view_model.dart';

class CParityRuleCreateModel {
  final int customerId;
  final int parityId;
  final bool isVisible;
  final SpreadRuleType? spreadRuleType;
  final double? spreadForAsk;
  final double? spreadForBid;

  CParityRuleCreateModel({
    required this.customerId,
    required this.parityId,
    required this.isVisible,
    this.spreadRuleType,
    this.spreadForAsk,
    this.spreadForBid,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'parityId': parityId,
      'isVisible': isVisible,
      'spreadRuleType': spreadRuleType?.id,
      'spreadForAsk': spreadForAsk,
      'spreadForBid': spreadForBid,
    };
  }
}
