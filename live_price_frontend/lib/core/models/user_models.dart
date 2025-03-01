import 'base_models.dart';

enum UserRole {
  admin,
  customer,
  customerAdmin,
}

class UserCreateModel {
  final String username;
  final String password;
  final String email;
  final String name;
  final String surname;
  final UserRole role;
  final int? customerId;

  UserCreateModel({
    required this.username,
    required this.password,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'name': name,
      'surname': surname,
      'role': role.toString().split('.').last,
      'customerId': customerId,
    };
  }
}

class UserUpdateModel {
  final String username;
  final String? password;
  final String email;
  final String name;
  final String surname;
  final UserRole role;
  final int? customerId;

  UserUpdateModel({
    required this.username,
    this.password,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'name': name,
      'surname': surname,
      'role': role.toString().split('.').last,
      'customerId': customerId,
    };
  }
}

class UserViewModel extends BaseAuditableDto {
  final String username;
  final String email;
  final String name;
  final String surname;
  final UserRole role;
  final int? customerId;
  final String? customerName;

  UserViewModel({
    required super.id,
    required this.username,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.customerId,
    this.customerName,
    super.createdAt,
    super.createdById,
    super.updatedAt,
    super.updatedById,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) {
    return UserViewModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      role: UserRole.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            json['role'].toString().toLowerCase(),
      ),
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
      'username': username,
      'email': email,
      'name': name,
      'surname': surname,
      'role': role.toString().split('.').last,
      'customerId': customerId,
      'customerName': customerName,
      'createdAt': createdAt?.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedById': updatedById,
    };
  }
}
