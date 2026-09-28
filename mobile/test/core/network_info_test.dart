import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobile/core/network/network_info.dart';

void main() {
  test('NetworkInfoImpl reports connectivity from the checker', () async {
    final connection = InternetConnection.createInstance(
      customConnectivityCheck: (option) async =>
          InternetCheckResult(option: option, isSuccess: true),
    );

    try {
      expect(await NetworkInfoImpl(connection).isConnected, isTrue);
    } finally {
      await connection.dispose();
    }
  });
}
