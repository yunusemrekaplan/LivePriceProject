import 'base_models.dart';
import 'parity_models.dart';

class ParityGroupCreateModel {
  final String name;
  final bool isEnabled;
  final int orderIndex;

  ParityGroupCreateModel({
    required this.name,
    required this.isEnabled,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
    };
  }
}

class ParityGroupUpdateModel {
  final String name;
  final bool isEnabled;
  final int orderIndex;

  ParityGroupUpdateModel({
    required this.name,
    required this.isEnabled,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
    };
  }
}

class ParityGroupViewModel extends BaseAuditableDto {
  final String name;
  final bool isEnabled;
  final int orderIndex;
  final List<ParityViewModel>? parities;

  ParityGroupViewModel({
    required super.id,
    required this.name,
    required this.isEnabled,
    required this.orderIndex,
    this.parities,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory ParityGroupViewModel.fromJson(Map<String, dynamic> json) {
    return ParityGroupViewModel(
      id: json['id'],
      name: json['name'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      parities: json['parities'] != null
          ? (json['parities'] as List)
              .map((e) => ParityViewModel.fromJson(e))
              .toList()
          : null,
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
      'parities': parities?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
