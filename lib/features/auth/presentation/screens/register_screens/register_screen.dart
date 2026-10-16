import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_states.dart';
import 'package:mobile/features/auth/presentation/widgets/register_widgets/register_screeen_widget.dart';

class RegisterScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        builder: (context, state) {
          if (state is LoadingRegisterState) {
            return Center(child: CircularProgressIndicator());
          }
          return RegisterScreeenWidget();
        },
        listener: (context, state) {
          if (state is SuccessRegisterState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Signed Up Successfully",
                  style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 5),
              ),
            );
          } else if (state is FailRegisterState) {
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
