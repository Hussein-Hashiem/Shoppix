import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';

void main() {
  test('maps timeout without a response to a connection timeout', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionTimeout,
      message: 'The connection timed out',
    );

    expect(
      () => handleDioException(exception),
      throwsA(
        isA<ConnectionTimeoutException>().having(
          (error) => error.errorModel.status,
          'status',
          408,
        ),
      ),
    );
  });

  test('maps an unmapped HTTP status to UnknownException', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/products'),
        statusCode: 418,
        data: <String, dynamic>{'message': 'I am a teapot'},
      ),
    );

    expect(
      () => handleDioException(exception),
      throwsA(
        isA<UnknownException>().having(
          (error) => error.errorModel.errorMessage,
          'error message',
          'I am a teapot',
        ),
      ),
    );
  });
}
