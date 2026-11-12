import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/dio_exception_handler.dart';
import 'package:mobile/core/errors/exception.dart';

void main() {
  group('handle dio exception error', () {
    
test('should return NetworkException for connectionTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'The connection is taking too long. Please check your internet connection and try again.',
      );
    });

    test('should return NetworkException for sendTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.sendTimeout,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'Your request is taking too long to send. Please try again.',
      );
    });

    test('should return NetworkException for receiveTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.receiveTimeout,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'The server is taking too long to respond. Please try again later.',
      );
    });

    test('should return NetworkException for connectionError', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'Unable to connect. Please check your internet connection.',
      );
    });

    test('should return NetworkException for cancel', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'The request was cancelled.',
      );
    });

    test('should return NetworkException for badCertificate', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badCertificate,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'A secure connection could not be established. Please try again later.',
      );
    });

    test('should return NetworkException for unknown error', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
      );

      final result = exception.handleDioExceptionError();

      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        'Something went wrong. Please try again later.',
      );
    });

  });
  test('should extract message from server response map', () {
    final exception = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 401,
        data: {'message': 'Invalid credentials'},
      ),
    );
    final result = exception.handleDioExceptionError();
    expect(result, isA<ServerException>());
    final serverException = result as ServerException;
    expect(serverException.message, 'Invalid credentials');
    expect(serverException.statusCode, 401);
  });

  test('should use response data when server response is a String', () {
    final exception = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: 'Something went wrong',
      ),
    );
    final result = exception.handleDioExceptionError();
    expect(result, isA<ServerException>());
    final serverException = result as ServerException;
    expect(serverException.message, 'Something went wrong');
    expect(serverException.statusCode, 500);
  });

  test('should use default message when server response has no message', () {
    final exception = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 500,
        data: {'error': 'Internal server error'},
      ),
    );
    final result = exception.handleDioExceptionError();
    expect(result, isA<ServerException>());
    final serverException = result as ServerException;
    expect(serverException.message, 'Server error');
    expect(serverException.statusCode, 500);
  });
}
