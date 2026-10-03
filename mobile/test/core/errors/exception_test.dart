import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';

void main() {
  group('ServerException', () {
    test('should store message and statusCode', () {
      final e = ServerException(message: 'Not found', statusCode: 404);

      expect(e.message, 'Not found');
      expect(e.statusCode, 404);
    });

    test('statusCode should be null when not provided', () {
      final e = ServerException(message: 'Error');

      expect(e.statusCode, isNull);
    });

    test('should be an Exception', () {
      expect(ServerException(message: 'x'), isA<Exception>());
    });
  });

  group('CacheException', () {
    test('should store message', () {
      final e = CacheException(message: 'Cache miss');

      expect(e.message, 'Cache miss');
      expect(e, isA<Exception>());
    });
  });

  group('NetworkException', () {
    test('should have default message when none provided', () {
      expect(NetworkException().message, 'No internet connection');
    });

    test('should use custom message when provided', () {
      expect(NetworkException(message: 'Timeout').message, 'Timeout');
    });

    test('should be an Exception', () {
      expect(NetworkException(), isA<Exception>());
    });
  });
}
