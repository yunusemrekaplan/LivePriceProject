import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  final String baseUrl = 'http://localhost:5104/api';
  late final Dio _dio;
  String? _token;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        validateStatus: (status) => status! < 500,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  void setToken(String token) {
    _token = token;
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
