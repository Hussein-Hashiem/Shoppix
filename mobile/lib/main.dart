import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/routing/app_router.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_cubit.dart';
import 'package:mobile/layout/presentation/cubit/layout_cubit.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Responsive.initFromView();
  await setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(create: (context) => sl<LoginCubit>()),
        BlocProvider(create: (context) => sl<RegisterCubit>()),
        BlocProvider(create: (context) => sl<GetAllProductsCubit>()..getAllProducts()),
        BlocProvider(create: (context)=>sl<CartCubit>()),
        BlocProvider(create: (context)=>sl<GetProductByIdCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      builder: (context, child) {
        Responsive.init(context);
        return child!;
      },
      title: 'Shoppix',
      theme: AppTheme.lightTheme,
    );
  }
}
