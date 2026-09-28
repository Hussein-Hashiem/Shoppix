import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';

void main() {
  group('Exceptions', () {
    test('preserve messages, status codes, and defaults', () {
      final serverException = ServerException(
        message: 'Unavailable',
        statusCode: 503,
      );
      final cacheException = CacheException(message: 'Cache miss');

      expect(serverException.message, 'Unavailable');
      expect(serverException.statusCode, 503);
      expect(cacheException.message, 'Cache miss');
      expect(NetworkException().message, 'No internet connection');
      expect(NetworkException(message: 'Offline').message, 'Offline');
    });
  });

  group('Failures', () {
    test('compare by message and distinguish failure types', () {
      expect(const ServerFailure('failed'), const ServerFailure('failed'));
      expect(
        const CacheFailure('failed'),
        isNot(const ServerFailure('failed')),
      );
      expect(const NetworkFailure('offline').props, ['offline']);
    });
  });
}
