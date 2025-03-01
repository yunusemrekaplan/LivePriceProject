class ParityUpdateModel {
  final String? name;
  final String? symbol;
  final bool? isEnabled;
  final int? orderIndex;
  final int? parityGroupId;

  ParityUpdateModel({
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (isEnabled != null) 'isEnabled': isEnabled,
      if (orderIndex != null) 'orderIndex': orderIndex,
    };
  }
}