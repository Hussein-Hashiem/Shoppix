import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await sl.reset();
  });

  group('setup()', () {
    test('should register Dio in GetIt', () async {
      await setup();

      expect(sl.isRegistered<Dio>(), isTrue);
    });

    test(
      'should return the same Dio instance every time (singleton)',
      () async {
        await setup();

        expect(identical(sl<Dio>(), sl<Dio>()), isTrue);
      },
    );

    test('should configure Dio BaseOptions correctly', () async {
      await setup();

      final options = sl<Dio>().options;

      expect(options.baseUrl, ApiEndpoints.baseUrl);
      expect(options.connectTimeout, const Duration(seconds: 15));
      expect(options.receiveTimeout, const Duration(seconds: 15));
      expect(options.headers['Content-Type'], 'application/json');
    });
  });
}
