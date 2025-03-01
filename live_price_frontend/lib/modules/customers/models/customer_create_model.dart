class CustomerCreateModel {
  final String name;

  CustomerCreateModel({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}