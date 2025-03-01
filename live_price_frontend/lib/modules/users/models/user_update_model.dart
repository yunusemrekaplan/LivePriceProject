import 'user_role.dart';

class UserUpdateModel {
  final String? username;
  final String? password;
  final String? email;
  final String? name;
  final String? surname;
  final UserRole? role;
  final int? customerId;

  UserUpdateModel({
    this.username,
    this.password,
    this.email,
    this.name,
    this.surname,
    this.role,
    this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'name': name,
      'surname': surname,
      'role': role?.id,
      'customerId': customerId,
    };
  }
}
