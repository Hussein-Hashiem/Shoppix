import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle titleLarge = GoogleFonts.geist(
    fontWeight: FontWeight.w500,
    color: AppColors.title,
    fontSize: Responsive.sp(26),
  );
  static TextStyle titleMedium = GoogleFonts.geist(
    fontWeight: FontWeight.w500,
    color: AppColors.title,
    fontSize: Responsive.sp(22),
  );
  static TextStyle bodyLarge = GoogleFonts.geist(
    fontWeight: FontWeight.normal,
    color: AppColors.bodyLarge,
    fontSize: Responsive.sp(14),
  );
  static TextStyle bodyMedium = GoogleFonts.geist(
    fontWeight: FontWeight.normal,
    color: AppColors.bodyLarge,
    fontSize: Responsive.sp(12),
  );
  static TextStyle bodySmall = GoogleFonts.geist(
    fontWeight: FontWeight.normal,
    color: AppColors.bodyLarge,
    fontSize: Responsive.sp(10),
  );
  static TextStyle hintStyle = GoogleFonts.geist(
    fontWeight: FontWeight.normal,
    color: AppColors.hint,
    fontSize: Responsive.sp(14),
  );
}
