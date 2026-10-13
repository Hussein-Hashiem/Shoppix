import 'package:flutter/material.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class LoginTextfield extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  Widget? prefix;
  Widget? suffix;
  final bool isPassword;
  final TextInputType keyboardType;

  LoginTextfield({
    super.key,
    required this.hint,
    required this.controller,
    required this.validator,
    this.prefix,
    this.suffix,
    required this.isPassword,
    required this.keyboardType,
  });

  @override
  State<LoginTextfield> createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<LoginTextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.w(356),
      child: TextFormField(
        obscureText: widget.isPassword,
        validator: widget.validator,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffix,
          hint: Text(widget.hint, style: AppTextStyles.hintStyle),
        ),
      ),
    );
  }
}
