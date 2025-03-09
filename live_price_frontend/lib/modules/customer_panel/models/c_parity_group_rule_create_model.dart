class CParityGroupRuleCreateModel {
  final int customerId;
  final int parityGroupId;
  final bool isVisible;

  CParityGroupRuleCreateModel({
    required this.customerId,
    required this.parityGroupId,
    required this.isVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'parityGroupId': parityGroupId,
      'isVisible': isVisible,
    };
  }
}
