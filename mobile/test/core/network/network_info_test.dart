import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/network/network_info.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late MockInternetConnection connection;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    connection = MockInternetConnection();
    networkInfo = NetworkInfoImpl(connection);
  });

  test('isConnected returns true when hasInternetAccess is true', () async {
    when(() => connection.hasInternetAccess).thenAnswer((_) async => true);

    expect(await networkInfo.isConnected, isTrue);
    verify(() => connection.hasInternetAccess).called(1);
  });

  test('isConnected returns false when hasInternetAccess is false', () async {
    when(() => connection.hasInternetAccess).thenAnswer((_) async => false);

    expect(await networkInfo.isConnected, isFalse);
  });
}
