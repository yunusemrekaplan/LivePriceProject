import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:live_price_frontend/core/services/token_service.dart';
import 'package:live_price_frontend/routes/app_pages.dart';
import 'package:live_price_frontend/core/services/infrastructure/interceptors/interceptors.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  final String _baseUrl = 'http://localhost:5104/api';
  late final dio.Dio _dio;
  final TokenService _tokenService = TokenService.instance;

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: _baseUrl,
        contentType: 'application/json',
        validateStatus: (status) => status! < 500,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(AuthInterceptor(_tokenService, _dio));
  }

  Future<dio.Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on dio.DioException {
      rethrow;
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on dio.DioException {
      rethrow;
    }
  }

  Future<dio.Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on dio.DioException {
      rethrow;
    }
  }

  Future<dio.Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on dio.DioException {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenService.removeToken();
    Get.offAllNamed(Routes.login);
  }
}
