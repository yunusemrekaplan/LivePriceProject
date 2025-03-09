class CParityGroupViewModel {
  final int id;
  final String? name;
  final String? description;
  final bool isVisible;

  CParityGroupViewModel({
    required this.id,
    this.name,
    this.description,
    required this.isVisible,
  });

  factory CParityGroupViewModel.fromJson(Map<String, dynamic> json) {
    return CParityGroupViewModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isVisible: json['isVisible'],
    );
  }
}
