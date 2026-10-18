import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_states.dart';
import 'package:mobile/features/auth/presentation/widgets/login_widgets/login_screen_widget.dart';
import 'package:mobile/widgets/custom_elevated_button.dart';
import 'package:mobile/widgets/custom_textfield.dart';
import 'package:mocktail/mocktail.dart';

class LoginCubitMock extends Mock implements LoginCubit {}

class RegisterCubitMock extends Mock implements RegisterCubit {}

// عشان مننكررش الجزئية دي في كل مرة بنعمل فيها تيست
Future<void> pumbLoginScreen(
  WidgetTester tester, {
  required LoginCubit loginCubit,
  String initialRoute = '/login',
  required RegisterCubit registerCubit,
}) async {
  final testRouter = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => loginCubit,
          child: LoginScreenWidget(),
        ),
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) => BlocProvider(
          create: (context) => registerCubit,
          child: RegisterScreen(),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(routerConfig: testRouter, theme: AppTheme.lightTheme),
  );
}

void main() {
  late LoginCubitMock loginCubitMock;
  late RegisterCubitMock registerCubitMock;
  setUp(() {
    loginCubitMock = LoginCubitMock();
    registerCubitMock = RegisterCubitMock();
    when(() => loginCubitMock.state).thenReturn(InitialLoginState());
    when(() => registerCubitMock.state).thenReturn(InitialRegisterState());

    when(() => loginCubitMock.stream).thenAnswer((_) => const Stream.empty());
    when(() => registerCubitMock.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => loginCubitMock.close()).thenAnswer((_) async => {});
    when(() => registerCubitMock.close()).thenAnswer((_) async => {});
  });

  group("LoginScreenWidget rendering tests", () {
    testWidgets("should render all textfields and buttons", (tester) async {
      await pumbLoginScreen(
        tester,
        loginCubit: loginCubitMock,
        registerCubit: registerCubitMock,
      );

      expect(find.byType(CustomTextfield), findsNWidgets(2));
      expect(
        find.widgetWithText(CustomElevatedButton, "Sign In"),
        findsNWidgets(1),
      );
    });
    testWidgets(
      "should show error in email field if it's invalid or empty and the same for the password",
      (tester) async {
        await pumbLoginScreen(
          tester,
          loginCubit: loginCubitMock,
          registerCubit: registerCubitMock,
        );

        await tester.enterText(find.byKey(Key("email")), "alimohamed");
        final buttonFinder = find.byType(CustomElevatedButton);

        // التمرير للأسفل حتى يظهر الزر على الشاشة ويصبح قابلاً للنقر
        await tester.scrollUntilVisible(
          buttonFinder,
          500.0, // مقدار التمرير في كل حركة
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.pump();

        expect(find.text('Enter a valid email'), findsOneWidget);

        await tester.enterText(find.byKey(Key("email")), "");

        // التمرير للأسفل حتى يظهر الزر على الشاشة ويصبح قابلاً للنقر
        await tester.scrollUntilVisible(
          buttonFinder,
          500.0, // مقدار التمرير في كل حركة
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.pump();

        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);

        await tester.enterText(find.byKey(Key("password")), "12345678");

        // التمرير للأسفل حتى يظهر الزر على الشاشة ويصبح قابلاً للنقر
        await tester.scrollUntilVisible(
          buttonFinder,
          500.0, // مقدار التمرير في كل حركة
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.pump();

        expect(
          find.text('Password must contain atlease one uppercase letter'),
          findsOneWidget,
        );
      },
    );

    testWidgets("should go to register screen after tabbing on the text", (
      tester,
    ) async {
      await pumbLoginScreen(
        tester,
        loginCubit: loginCubitMock,
        registerCubit: registerCubitMock,
      );

      await tester.scrollUntilVisible(
        find.text("Create an Account"),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text("Create an Account"));
      await tester.pumpAndSettle();

      expect(find.text("CREATE ACCOUNT"), findsOneWidget);
    });
  });
}
