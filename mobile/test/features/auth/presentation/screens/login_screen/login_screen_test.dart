import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_states.dart';
import 'package:mobile/widgets/custom_elevated_button.dart';
import 'package:mobile/widgets/custom_textfield.dart';
import 'package:mocktail/mocktail.dart';

class LoginCubitMock extends Mock implements LoginCubit {}

class GetAllProductsCubitMock extends Mock implements GetAllProductsCubit {}

Future<void> pumpLoginScreen(
  WidgetTester tester, {
  required LoginCubit loginCubit,
  required GetAllProductsCubit productsCubit,
  String initialRoute = Routes.login,
}) async {
  final testRouter = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: loginCubit),
            BlocProvider.value(value: productsCubit),
          ],
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.browseProducts,
        name: Routes.browseProducts,
        builder: (context, state) => const Scaffold(body: SizedBox()),
      ),
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(routerConfig: testRouter, theme: AppTheme.lightTheme),
  );
}

void main() {
  late LoginCubitMock loginCubitMock;
  late GetAllProductsCubitMock productsCubitMock;
  late StreamController<LoginStates> loginStateController;

  setUp(() {
    loginCubitMock = LoginCubitMock();
    productsCubitMock = GetAllProductsCubitMock();
    loginStateController = StreamController<LoginStates>.broadcast();

    when(() => loginCubitMock.state).thenReturn(InitialLoginState());
    when(() => loginCubitMock.stream)
        .thenAnswer((_) => loginStateController.stream);
    when(() => loginCubitMock.close()).thenAnswer((_) async {});

    when(() => productsCubitMock.state)
        .thenReturn(InitialGetAllProductState());
    when(() => productsCubitMock.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => productsCubitMock.close()).thenAnswer((_) async {});
    when(() => productsCubitMock.getAllProducts()).thenReturn(null);
  });

  tearDown(() async {
    await loginStateController.close();
  });

  group('Login Screen tests', () {
    testWidgets('should render login widgets in the initial state', (tester) async {
      await pumpLoginScreen(
        tester,
        loginCubit: loginCubitMock,
        productsCubit: productsCubitMock,
      );

      expect(find.byType(CustomTextfield), findsNWidgets(2));
      expect(find.widgetWithText(CustomElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('should show a success snackbar when login succeeds', (
      tester,
    ) async {
      await pumpLoginScreen(
        tester,
        loginCubit: loginCubitMock,
        productsCubit: productsCubitMock,
      );

      loginStateController.add(SuccessLoginState());
      await tester.pump();

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
      expect(find.text('Signed In Successfully'), findsOneWidget);
    });

    testWidgets('should show a failure snackbar when login fails', (
      tester,
    ) async {
      await pumpLoginScreen(
        tester,
        loginCubit: loginCubitMock,
        productsCubit: productsCubitMock,
      );

      loginStateController.add(FailLoginState(message: 'Invalid credentials'));
      await tester.pump();

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
