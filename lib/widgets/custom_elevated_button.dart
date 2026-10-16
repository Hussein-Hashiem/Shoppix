import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget content;
  final void Function() onPressed;
  final double width;
  final double height;
  const new({
    super.key,
    required this.content,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(fixedSize: Size(width, height)),
      child: content,
    );
  }
}
