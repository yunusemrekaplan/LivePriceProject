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

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
