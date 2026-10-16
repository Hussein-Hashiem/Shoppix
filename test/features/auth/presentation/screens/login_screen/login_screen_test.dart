import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/widgets/custom_elevated_button.dart';
import 'package:mobile/widgets/custom_textfield.dart';
import 'package:mocktail/mocktail.dart';

class LoginCubitMock extends Mock implements LoginCubit {}

// عشان مننكررش الجزئية دي في كل مرة بنعمل فيها تيست
Future<void> pumbLoginScreen(
  WidgetTester tester, {
  required LoginCubit loginCubit,
  String initialRoute = '/login',
}) async {
  final testRouter = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) =>
            BlocProvider(create: (context) => loginCubit, child: LoginScreen()),
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(routerConfig: testRouter, theme: AppTheme.lightTheme),
  );
}

void main() {
  late LoginCubitMock loginCubitMock;
  late StreamController<LoginStates> loginStateController;
  setUp(() {
    loginCubitMock = LoginCubitMock();
    loginStateController = StreamController<LoginStates>.broadcast();
    when(() => loginCubitMock.state).thenReturn(InitialLoginState());
    when(() => loginCubitMock.stream)
        .thenAnswer((_) => loginStateController.stream);
    when(() => loginCubitMock.close()).thenAnswer((_) async => {});
  });

  group("Login Screen tests", () {
    testWidgets("should render LoginWidgetScreen in Initial state", (
      tester,
    ) async {
      await pumbLoginScreen(tester, loginCubit: loginCubitMock);

      expect(find.byType(CustomTextfield), findsNWidgets(2));
      expect(
        find.widgetWithText(CustomElevatedButton, "Sign In"),
        findsNWidgets(1),
      );
    });
    testWidgets("should render green snackbar with a text in Success state", (
      tester,
    ) async {
      await pumbLoginScreen(tester, loginCubit: loginCubitMock);

      when(() => loginCubitMock.state).thenReturn(SuccessLoginState());
      loginStateController.add(SuccessLoginState());
      await tester.pump();

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
      expect(find.text("Signed In Successfully"), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      await tester.pump(const Duration(milliseconds: 750));

      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
