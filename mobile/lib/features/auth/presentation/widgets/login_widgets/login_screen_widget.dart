import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/icon_assets.dart';
import 'package:mobile/core/utils/constants/image_assets.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/core/utils/validators/validators.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_cubit.dart';
import 'package:mobile/widgets/custom_textfield.dart';
import 'package:mobile/widgets/custom_elevated_button.dart';

class LoginScreenWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key("appBar"),
        title: Text(
          key: Key("title"),
          "Checkout Workflow",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(16),
              vertical: Responsive.h(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Responsive.w(40),
                  height: Responsive.h(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffEEEEEE),
                  ),
                  child: SvgPicture.asset(IconAssets.lock, fit: BoxFit.none),
                ),
                SizedBox(height: Responsive.h(8)),
                Text("Sign In", style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: Responsive.h(4)),
                Text(
                  "Welcome back. Enter your credentials to access your bag and saved items.",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.h(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImageAssets.login1,
                      width: Responsive.w(111.33),
                      height: Responsive.h(139),
                    ),
                    Image.asset(
                      ImageAssets.login2,
                      width: Responsive.w(111.33),
                      height: Responsive.h(139),
                    ),
                    Image.asset(
                      ImageAssets.login3,
                      width: Responsive.w(111.33),
                      height: Responsive.h(139),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "EMAIL ADDRESS",
                      style: Theme.of(context).textTheme.bodyLarge!
                          .copyWith(color: AppColors.label),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(4)),
                CustomTextfield(
                  key: Key("email"),
                  hint: "curator@shoppix.app",
                  controller: email,
                  validator: (val) {
                    return Validators.email(val);
                  },
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Responsive.h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "PASSWORD",
                      style: Theme.of(context).textTheme.bodyLarge!
                          .copyWith(color: AppColors.label),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(4)),
                CustomTextfield(
                  key: Key("password"),
                  hint: "••••••••••••",
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
                SizedBox(height: Responsive.h(16)),
                CustomElevatedButton(
                  content: Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.buttonText,
                      letterSpacing: Responsive.w(1.3),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<LoginCubit>(context)
                          .login(email: email.text, password: password.text);
                    }
                  },
                  height: Responsive.h(48),
                  width: Responsive.w(358),
                ),
                SizedBox(height: Responsive.h(4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    InkWell(
                      onTap: () {
                        context.pushNamed(Routes.register);
                      },
                      child: Text(
                        "Create an Account",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.outlinedBorder,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
