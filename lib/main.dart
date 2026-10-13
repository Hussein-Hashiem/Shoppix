import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/screens/login_screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/widgets/login_widgets/login_screen_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Responsive.initFromView();
  setup();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<LoginCubit>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        Responsive.init(context);
        return child!;
      },
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}
