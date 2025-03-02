class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    this.success = true,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson({
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
    bool success = true,
    dynamic data,
    String? message,
    int? statusCode,
  }) {
    if (data is List && fromJsonList != null) {
      return ApiResponse<T>(
        success: success,
        data: fromJsonList(data),
        message: message,
        statusCode: statusCode,
      );
    } else {
      return ApiResponse<T>(
        success: success,
        data: fromJson != null ? fromJson(data as Map<String, dynamic>) : data,
        message: message,
        statusCode: statusCode,
      );
    }
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}