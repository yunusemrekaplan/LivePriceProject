class ParityCreateModel {
  final String name;
  final String symbol;
  final String apiSymbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;

  ParityCreateModel({
    required this.name,
    required this.symbol,
    required this.apiSymbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'apiSymbol': apiSymbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'parityGroupId': parityGroupId,
    };
  }
}
