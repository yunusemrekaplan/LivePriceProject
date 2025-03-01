// Login modelleri
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final int id;
  final String userName;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.id,
    required this.userName,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      userName: json['userName'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

// Register modelleri
class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String name;
  final String surname;
  final String role;
  final int? customerId;

  RegisterRequest({
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
      'role': role,
      'customerId': customerId,
    };
  }
}

// Refresh token modelleri
class RefreshRequest {
  final String refreshToken;

  RefreshRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  RefreshResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
