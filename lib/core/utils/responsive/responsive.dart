import 'package:flutter/material.dart';

abstract class Responsive {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;

  static const double _designWidth = 390;
  static const double _designHeight = 884;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    screenHeight = size.height;

    scaleWidth = screenWidth / _designWidth;
    scaleHeight = screenHeight / _designHeight;
  }

  static double w(double value) => value * scaleWidth;
  static double h(double value) => value * scaleHeight;
  static double sp(double value) {
    final scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
    return value * scale;
  }

  static double r(double value) => value * scaleWidth;
}
