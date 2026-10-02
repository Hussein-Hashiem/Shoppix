import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';

void main() {
  test('ApiEndpoints exposes the authentication routes', () {
    expect(ApiEndpoints.baseUrl, isEmpty);
    expect(ApiEndpoints.login, '/auth/login');
    expect(ApiEndpoints.register, '/auth/register');
  });
}
