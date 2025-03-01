import 'user_role.dart';

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
      'role': role.id,
      'customerId': customerId,
    };
  }
}
