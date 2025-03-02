import 'package:dio/dio.dart' hide Response;
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../models/response_model.dart';

class ApiClient extends GetxService {
  final _dio = Get.find<Dio>();

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson, fromJsonList);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson, fromJsonList);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson, fromJsonList);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson, fromJsonList);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );

      return _handleResponse(response, fromJson, fromJsonList);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    dio.Response response,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  ) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return ApiResponse.fromJson(
          fromJson: fromJson,
          data: response.data,
          message: response.statusMessage,
          statusCode: response.statusCode,
        );
      } else if (response.data is List && fromJsonList != null) {
        return ApiResponse.fromJson(
          fromJsonList: fromJsonList,
          data: response.data,
          message: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse<T>(
        success: true,
        data: response.data as T?,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      response.statusMessage ?? 'Bir hata oluştu',
      statusCode: response.statusCode,
    );
  }

  ApiResponse<T> _handleError<T>(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Bağlantı zaman aşımına uğradı';
        break;
      case DioExceptionType.badResponse:
        message = error.response?.data['message'] ?? 'Sunucu hatası';
        break;
      case DioExceptionType.cancel:
        message = 'İstek iptal edildi';
        break;
      default:
        message = 'Bir hata oluştu';
        break;
    }

    return ApiResponse.error(
      message,
      statusCode: error.response?.statusCode,
    );
  }
}
