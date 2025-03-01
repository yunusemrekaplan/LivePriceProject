import 'base_models.dart';
import 'customer_price_rule_models.dart';
import 'user_models.dart';

class CustomerCreateModel {
  final String name;
  final String apiKey;

  CustomerCreateModel({
    required this.name,
    required this.apiKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'apiKey': apiKey,
    };
  }
}

class CustomerUpdateModel {
  final String name;
  final String apiKey;

  CustomerUpdateModel({
    required this.name,
    required this.apiKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'apiKey': apiKey,
    };
  }
}

class CustomerViewModel extends BaseAuditableDto {
  final String name;
  final String apiKey;
  final List<UserViewModel>? users;
  final List<CustomerPriceRuleViewModel>? customerPriceRules;

  CustomerViewModel({
    required super.id,
    required this.name,
    required this.apiKey,
    this.users,
    this.customerPriceRules,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory CustomerViewModel.fromJson(Map<String, dynamic> json) {
    return CustomerViewModel(
      id: json['id'],
      name: json['name'],
      apiKey: json['apiKey'],
      users: json['users'] != null
          ? (json['users'] as List)
              .map((e) => UserViewModel.fromJson(e))
              .toList()
          : null,
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
      'apiKey': apiKey,
      'users': users?.map((e) => e.toJson()).toList(),
      'customerPriceRules': customerPriceRules?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
