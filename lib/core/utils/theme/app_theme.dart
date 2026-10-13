import 'package:flutter/material.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
    ),
    appBarTheme: AppBarTheme(backgroundColor: AppColors.appBar),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.outlinedButtonText,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: Responsive.w(1),
            color: AppColors.outlinedBorder,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.hintStyle,
      fillColor: AppColors.textFieldFillColor,
      border: OutlineInputBorder(
        borderSide: BorderSide(width: Responsive.w(1), color: AppColors.border),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: Responsive.w(1), color: AppColors.error),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: Responsive.w(1),
          color: AppColors.outlinedBorder,
        ),
      ),
    ),
  );
}
