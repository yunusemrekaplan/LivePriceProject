class ApiConfig {
  static const String baseUrl = 'http://localhost:5104/api';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': '*/*',
  };

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  static const String users = '/users';
  static const String customers = '/customers';
  static const String parities = '/parities';
  static const String parityGroups = '/parityGroups';
}
