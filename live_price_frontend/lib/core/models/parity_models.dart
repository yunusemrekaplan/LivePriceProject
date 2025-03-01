import 'base_models.dart';
import 'customer_price_rule_models.dart';

class ParityCreateModel {
  final String name;
  final String symbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;

  ParityCreateModel({
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'parityGroupId': parityGroupId,
    };
  }
}

class ParityUpdateModel {
  final String name;
  final String symbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;

  ParityUpdateModel({
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'parityGroupId': parityGroupId,
    };
  }
}

class ParityViewModel extends BaseAuditableDto {
  final String name;
  final String symbol;
  final bool isEnabled;
  final int orderIndex;
  final int parityGroupId;
  final String? parityGroupName;
  final List<CustomerPriceRuleViewModel>? customerPriceRules;

  ParityViewModel({
    required super.id,
    required this.name,
    required this.symbol,
    required this.isEnabled,
    required this.orderIndex,
    required this.parityGroupId,
    this.parityGroupName,
    this.customerPriceRules,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory ParityViewModel.fromJson(Map<String, dynamic> json) {
    return ParityViewModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      isEnabled: json['isEnabled'],
      orderIndex: json['orderIndex'],
      parityGroupId: json['parityGroupId'],
      parityGroupName: json['parityGroupName'],
      customerPriceRules: json['customerPriceRules'] != null
          ? (json['customerPriceRules'] as List)
              .map((e) => CustomerPriceRuleViewModel.fromJson(e))
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
      'symbol': symbol,
      'isEnabled': isEnabled,
      'orderIndex': orderIndex,
      'parityGroupId': parityGroupId,
      'parityGroupName': parityGroupName,
      'customerPriceRules': customerPriceRules?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
