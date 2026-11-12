import 'package:dio/dio.dart';
import 'package:mobile/core/errors/exception.dart';

extension DioExceptionHandler on DioException {
  Exception handleDioExceptionError() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: 'The connection is taking too long. Please check your internet connection and try again.',
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Your request is taking too long to send. Please try again.',
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'The server is taking too long to respond. Please try again later.',
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Unable to connect. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return extractServerException();
      case DioExceptionType.cancel:
        return NetworkException(message: 'The request was cancelled.');
      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'A secure connection could not be established. Please try again later.',
        );
      case DioExceptionType.unknown:
      default:
        if (response != null) {
          return extractServerException();
        }
        return NetworkException(
          message: 'Something went wrong. Please try again later.',
        );
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
