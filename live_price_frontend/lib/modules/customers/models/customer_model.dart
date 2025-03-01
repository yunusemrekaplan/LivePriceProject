class CustomerModel {
  final int id;
  final String name;
  final String apiKey;
  final DateTime? createdAt;
  final int? createdById;
  final DateTime? updatedAt;
  final int? updatedById;

  CustomerModel({
    required this.id,
    required this.name,
    required this.apiKey,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.updatedById,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      apiKey: json['apiKey'],
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
      'apiKey': apiKey,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
