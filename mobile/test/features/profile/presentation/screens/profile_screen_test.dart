import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageMock extends Mock implements FlutterSecureStorage {}

void main() {
  testWidgets('shows user details and clears stored credentials on logout', (
    tester,
  ) async {
    final secureStorage = FlutterSecureStorageMock();
    when(() => secureStorage.read(key: 'user_name'))
        .thenAnswer((_) async => 'Alice Example');
    when(() => secureStorage.read(key: 'user_email'))
        .thenAnswer((_) async => 'alice@example.com');
    when(() => secureStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});

    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              ProfileScreen(storage: SecureTokenStorage(secureStorage)),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Alice Example'), findsNWidgets(2));
    expect(find.text('alice@example.com'), findsNWidgets(2));
    expect(find.text('A'), findsOneWidget);

    await tester.tap(find.text('LOG OUT'));
    await tester.pumpAndSettle();

    expect(find.text('Login page'), findsOneWidget);
    verify(() => secureStorage.delete(key: 'auth_token')).called(1);
    verify(() => secureStorage.delete(key: 'user_name')).called(1);
    verify(() => secureStorage.delete(key: 'user_email')).called(1);
  });
}
