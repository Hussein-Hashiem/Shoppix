import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/register_screens/register_screen.dart';
import 'package:mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:mobile/features/cart/presentation/screens/order_summary_screen.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:mobile/features/order/presentation/viewmodel/orders_cubit.dart';
import 'package:mobile/features/order_history/presentation/screens/orders_screen.dart';
import 'package:mobile/features/product/presentation/screens/browse_products_screens/browse_products_screen.dart';
import 'package:mobile/features/product/presentation/screens/product_details_screen/product_details_screen.dart';
import 'package:mobile/layout/presentation/pages/layout_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    const protectedLocations = {'/', Routes.browseProducts,Routes.cart,Routes.profile};
    if (!protectedLocations.contains(state.matchedLocation)) {
      return null;
    }

    final token = await sl<SecureTokenStorage>().readToken();
    if (token == null || token.isEmpty) {
      return Routes.login;
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return LayoutScreen(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          name: 'shop',
          builder: (context, state) => const BrowseProductsScreen(),
        ),
        GoRoute(
          path: '/cart',
          name: Routes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: Routes.orderHistory,
          name: Routes.orderHistory,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<OrdersCubit>()..getOrders(),
            child: const OrdersScreen(),
          ),
        ),
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
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
      path: Routes.orderSummary,
      name: Routes.orderSummary,
      builder: (context, state) {
        final data = state.extra;
        if (data is! OrderSummaryData) {
          throw StateError('Order summary requires order and cart data.');
        }
        return OrderSummaryScreen(data: data);
      },
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
