import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
