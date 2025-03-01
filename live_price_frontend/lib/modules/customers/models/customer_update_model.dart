class CustomerUpdateModel {
  final String name;

  CustomerUpdateModel({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}