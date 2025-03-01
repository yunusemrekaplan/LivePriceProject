class ParityGroupUpdateModel {
  final String? name;
  final String? description;
  final bool? isEnabled;
  final int? orderIndex;

  ParityGroupUpdateModel({
    this.name,
    this.description,
    this.isEnabled,
    this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (isEnabled != null) 'isEnabled': isEnabled,
      if (orderIndex != null) 'orderIndex': orderIndex,
    };
  }
  
}