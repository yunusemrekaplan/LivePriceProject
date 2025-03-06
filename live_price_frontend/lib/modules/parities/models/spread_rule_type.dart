enum SpreadRuleType {
  fixed(0, 'Fixed'),
  percentage(1, 'Percentage');

  final int id;
  final String name;

  const SpreadRuleType(this.id, this.name);

  static SpreadRuleType fromId(int id) {
    return SpreadRuleType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Invalid spread rule type: $id'),
    );
  }
}