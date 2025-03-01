class ParityGroupCreateModel {
  final String name;
  final String description;
  final bool isEnabled;
  final int orderIndex;

  ParityGroupCreateModel({
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
    };
  }
}