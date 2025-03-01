class ParityGroupModel {
  final int id;
  final String name;
  final bool isEnabled;
  final int orderIndex;
  final DateTime? createdAt;
  final int? createdById;
  final DateTime? updatedAt;
  final int? updatedById;

  ParityGroupModel({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.orderIndex,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.updatedById,
  });

  factory ParityGroupModel.fromJson(Map<String, dynamic> json) {
    return ParityGroupModel(
      id: json['id'],
      name: json['name'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
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
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
