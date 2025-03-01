enum UserRole {
  admin,
  customer;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.customer:
        return 'Müşteri';
    }
  }
}

class UserModel {
  final int id;
  final String name;
  final String surname;
  final String username;
  final String email;
  final UserRole role;
  final int? customerId;
  final String? customerName;
  final DateTime? createdAt;
  final int? createdById;
  final DateTime? updatedAt;
  final int? updatedById;

  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.role,
    this.customerId,
    this.customerName,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.updatedById,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      role: UserRole.values
          .firstWhere((e) => e.name == json['role'].toString().toLowerCase()),
      customerId: json['customerId'],
      customerName: json['customerName'],
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
      'surname': surname,
      'username': username,
      'email': email,
      'role': role.name,
      'customerId': customerId,
      'customerName': customerName,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
