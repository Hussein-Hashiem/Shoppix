import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';

void main() {
  group('setupDio', () {
    tearDown(() async {
      await sl.reset();
    });

    test('registers Dio with the expected defaults', () {
      setup();

      expect(sl.isRegistered<Dio>(), isTrue);
      final dio = sl<Dio>();
      expect(dio.options.baseUrl, ApiEndpoints.baseUrl);
      expect(dio.options.connectTimeout, const Duration(seconds: 15));
      expect(dio.options.receiveTimeout, const Duration(seconds: 15));
      expect(dio.options.headers['Content-Type'], 'application/json');
    });
  });
}
