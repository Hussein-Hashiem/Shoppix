import 'dart:ui' as ui;

import 'package:flutter/material.dart';

abstract class Responsive {
  static double screenWidth = _designWidth;
  static double screenHeight = _designHeight;
  static double scaleWidth = 1;
  static double scaleHeight = 1;

  static const double _designWidth = 390;
  static const double _designHeight = 884;

  /// Call in main() before runApp, no context needed.
  static void initFromView() {
    final view = ui.PlatformDispatcher.instance.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    _update(size);
  }

  /// Call in MaterialApp.builder to react to rotation / window resize.
  static void init(BuildContext context) {
    _update(MediaQuery.sizeOf(context));
  }

  static void _update(Size size) {
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
