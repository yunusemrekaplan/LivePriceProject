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
}
