import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Widget content;
  final void Function() onPressed;
  final double width;
  final double height;
  const new({
    super.key,
    required this.content,
    required this.height,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(fixedSize: Size(width, height)),
      child: content,
    );
  }
}
