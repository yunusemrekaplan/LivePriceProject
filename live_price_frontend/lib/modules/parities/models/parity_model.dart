class ParityModel {
  final int id;
  final String name;
  final String symbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;
  final String? parityGroupName;
  final DateTime? createdAt;
  final int? createdById;
  final DateTime? updatedAt;
  final int? updatedById;

  ParityModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
    this.parityGroupName,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.updatedById,
  });

  factory ParityModel.fromJson(Map<String, dynamic> json) {
    return ParityModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      parityGroupId: json['parityGroupId'],
      parityGroupName: json['parityGroupName'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      createdById: json['createdById'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedById: json['updatedById'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'parityGroupId': parityGroupId,
      'parityGroupName': parityGroupName,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
