import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/dio_exception_failure_handler.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';

void main() {
  group('handle dio exception error', () {
    test('should return NetworkException for connectionTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Connection timeout');
    });

    test('should return NetworkException for sendTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.sendTimeout,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Connection timeout');
    });

    test('should return NetworkException for receiveTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.receiveTimeout,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Connection timeout');
    });

    test('should return NetworkException for connectionError', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Connection timeout');
    });
    test('should return ServerException for badResponse', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<ServerException>());
      final serverException = result as ServerException;
      expect(serverException.message, 'Server error');
    });

    test('should return NetworkException for cancel', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Request was cancelled');
    });

    test('should return NetworkException for badCertificate', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badCertificate,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Bad SSL certificate');
    });

    test('should return NetworkException for unknown error', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
      );
      final result = exception.handleDioExceptionError();
      expect(result, isA<NetworkException>());
      final networkException = result as NetworkException;
      expect(networkException.message, 'Unexpected network error occurred');
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

  group('handle dio failure', () {
    test('should return NetworkFailure for connectionTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Connection timeout');
    });

    test('should return NetworkFailure for sendTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.sendTimeout,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Connection timeout');
    });

    test('should return NetworkFailure for receiveTimeout', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.receiveTimeout,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Connection timeout');
    });

    test('should return NetworkFailure for connectionError', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Connection timeout');
    });

    test('should return ServerFailure for badResponse', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<ServerFailure>());
      expect(result.message, 'Server error');
    });

    test('should return NetworkFailure for cancel', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Request was cancelled');
    });

    test('should return NetworkFailure for badCertificate', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badCertificate,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Bad SSL certificate');
    });

    test('should return NetworkFailure for unknown error without response', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
      );
      final result = exception.handleDioFailure();
      expect(result, isA<NetworkFailure>());
      expect(result.message, 'Unexpected network error occurred');
    });

    test('should return ServerFailure for unknown error with response', () {
      final exception = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 500,
          data: 'Something went wrong',
        ),
      );
      final result = exception.handleDioFailure();
      expect(result, isA<ServerFailure>());
      expect(result.message, 'Something went wrong');
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
      final result = exception.handleDioFailure();
      expect(result, isA<ServerFailure>());
      expect(result.message, 'Invalid credentials');
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
      final result = exception.handleDioFailure();
      expect(result, isA<ServerFailure>());
      expect(result.message, 'Something went wrong');
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
      final result = exception.handleDioFailure();
      expect(result, isA<ServerFailure>());
      expect(result.message, 'Server error');
    });
  });
}
