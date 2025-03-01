import 'base_models.dart';

class CustomerPriceRuleCreateModel {
  final int customerId;
  final int parityId;
  final double buySpread;
  final double sellSpread;
  final bool isEnabled;

  CustomerPriceRuleCreateModel({
    required this.customerId,
    required this.parityId,
    required this.buySpread,
    required this.sellSpread,
    required this.isEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'parityId': parityId,
      'buySpread': buySpread,
      'sellSpread': sellSpread,
      'isEnabled': isEnabled,
    };
  }
}

class CustomerPriceRuleUpdateModel {
  final int customerId;
  final int parityId;
  final double buySpread;
  final double sellSpread;
  final bool isEnabled;

  CustomerPriceRuleUpdateModel({
    required this.customerId,
    required this.parityId,
    required this.buySpread,
    required this.sellSpread,
    required this.isEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'parityId': parityId,
      'buySpread': buySpread,
      'sellSpread': sellSpread,
      'isEnabled': isEnabled,
    };
  }
}

class CustomerPriceRuleViewModel extends BaseAuditableDto {
  final int customerId;
  final String? customerName;
  final int parityId;
  final String? parityName;
  final double buySpread;
  final double sellSpread;
  final bool isEnabled;

  CustomerPriceRuleViewModel({
    required super.id,
    required this.customerId,
    this.customerName,
    required this.parityId,
    this.parityName,
    required this.buySpread,
    required this.sellSpread,
    required this.isEnabled,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory CustomerPriceRuleViewModel.fromJson(Map<String, dynamic> json) {
    return CustomerPriceRuleViewModel(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      parityId: json['parityId'],
      parityName: json['parityName'],
      buySpread: json['buySpread'].toDouble(),
      sellSpread: json['sellSpread'].toDouble(),
      isEnabled: json['isEnabled'],
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
      'customerId': customerId,
      'customerName': customerName,
      'parityId': parityId,
      'parityName': parityName,
      'buySpread': buySpread,
      'sellSpread': sellSpread,
      'isEnabled': isEnabled,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
