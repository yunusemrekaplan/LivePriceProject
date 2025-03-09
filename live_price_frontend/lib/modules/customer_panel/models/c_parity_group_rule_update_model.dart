class CParityGroupRuleUpdateModel {
  final bool isVisible;

  CParityGroupRuleUpdateModel({
    required this.isVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'isVisible': isVisible,
    };
  }
}
