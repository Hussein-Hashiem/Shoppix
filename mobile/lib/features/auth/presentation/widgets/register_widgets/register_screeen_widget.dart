import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/icon_assets.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/core/utils/validators/validators.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_cubit.dart';
import 'package:mobile/widgets/custom_elevated_button.dart';
import 'package:mobile/widgets/custom_textfield.dart';

class RegisterScreeenWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<RegisterScreeenWidget> createState() => _RegisterScreeenWidgetState();
}

class _RegisterScreeenWidgetState extends State<RegisterScreeenWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout Flow",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: Responsive.h(24),
          horizontal: Responsive.w(16),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SHOPPIX IDENTITY 02",
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: AppColors.title),
                ),
                SizedBox(height: Responsive.h(8)),
                Text(
                  "CREATE ACCOUNT",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  "Join the studio community for curated collections and quiet design discoveries.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: Responsive.h(16)),
                Text(
                  "FULL NAME",
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: AppColors.label),
                ),
                SizedBox(height: Responsive.h(4)),
                CustomTextfield(
                  hint: "Alex Mercer",
                  controller: name,
                  validator: (val) {
                    return Validators.required(val);
                  },
                  isPassword: false,
                  keyboardType: TextInputType.text,
                  suffix: Icon(Icons.person_outline),
                ),
                SizedBox(height: Responsive.h(24)),
                Text(
                  "EMAIL ADDRESS",
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: AppColors.label),
                ),
                SizedBox(height: Responsive.h(4)),
                CustomTextfield(
                  hint: "alex@example.com",
                  controller: email,
                  validator: (val) {
                    return Validators.email(val);
                  },
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                  suffix: SvgPicture.asset(IconAssets.email, fit: BoxFit.none),
                ),
                SizedBox(height: Responsive.h(24)),
                Text(
                  "PASSWORD",
                  style: Theme.of(context).textTheme.bodySmall!
                      .copyWith(color: AppColors.label),
                ),
                SizedBox(height: Responsive.h(4)),
                CustomTextfield(
                  hint: "Create A Password",
                  controller: password,
                  validator: (val) {
                    return Validators.password(val);
                  },
                  isPassword: isPassword,
                  suffix: InkWell(
                    onTap: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    child: !isPassword
                        ? Icon(Icons.remove_red_eye)
                        : Icon(Icons.remove_red_eye_outlined),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: Responsive.h(4)),
                Divider(),
                SizedBox(height: Responsive.h(32)),
                CustomElevatedButton(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "REGISTER",
                        style: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: AppColors.buttonText),
                      ),
                      SizedBox(width: Responsive.w(4)),
                      SvgPicture.asset(
                        IconAssets.arrowRight,
                        fit: BoxFit.none,
                        width: Responsive.w(12),
                        height: Responsive.h(12),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<RegisterCubit>(context).register(
                        email: email.text,
                        password: password.text,
                        name: name.text,
                      );
                      context.pop();
                    }
                  },
                  height: Responsive.h(48),
                  width: Responsive.w(358),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
