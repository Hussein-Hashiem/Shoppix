import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';
import 'package:mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:mobile/features/product/presentation/screens/browse_products_screens/browse_products_screen.dart';
import 'package:mobile/features/product/presentation/screens/product_details_screen/product_details_screen.dart';
import 'package:mobile/layout/presentation/pages/layout_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return LayoutScreen(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'shop',
          builder: (context, state) => const BrowseProductsScreen(),
        ),
        GoRoute(
          path: '/cart',
          name: Routes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => const CartScreen(), // Replace with OrdersScreen
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const CartScreen(), // Replace with ProfileScreen
        ),
      ],
    ),
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
    GoRoute(
      path: Routes.browseProducts,
      name: Routes.browseProducts,
      builder: (context, state) => const BrowseProductsScreen(),
    ),
    GoRoute(
      path: Routes.productDetails,
      name: Routes.productDetails,
      builder: (context, state) {
        final productId = int.parse(state.pathParameters['id']!);
        return ProductDetailsScreen(productId: productId);
      },
    ),
  ],
);
