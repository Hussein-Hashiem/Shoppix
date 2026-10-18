import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/features/auth/presentation/widgets/login_widgets/login_screen_widget.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';

class LoginScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) {
          if (state is LoadingLoginState) {
            return Center(child: CircularProgressIndicator());
          }
          return LoginScreenWidget();
        },
        listener: (context, state) {
          if (state is SuccessLoginState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Signed In Successfully",
                  style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 5),
              ),
            );
            BlocProvider.of<GetAllProductsCubit>(context).getAllProducts();
            context.pushReplacement(Routes.browseProducts);
          } else if (state is FailLoginState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                duration: Duration(seconds: 5),
              ),
            );
          }
        },
      ),
    );
  }
}
