import 'package:dio/dio.dart';
import 'package:mobile/core/errors/exception.dart';

extension DioExceptionX on DioException {
  Exception handleDioExceptionError() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Connection timeout');

      case DioExceptionType.badResponse:
        return extractServerException();

      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return NetworkException(message: 'Bad SSL certificate');

      case DioExceptionType.unknown:
      default:
        if (response != null) {
          return extractServerException();
        }
        return NetworkException(message: 'Unexpected network error occurred');
    }
  }

  ServerException extractServerException() {
    final data = response?.data;
    String? message;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString();
    } else if (data is String) {
      message = data;
    }

    return ServerException(
      message: message ?? 'Server error',
      statusCode: response?.statusCode,
    );
  }
}
