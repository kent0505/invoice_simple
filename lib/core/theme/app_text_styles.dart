import 'package:flutter/material.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';

class MontserratTextStyle extends TextStyle {
  const MontserratTextStyle({
    super.fontSize,
    super.fontWeight,
    super.fontStyle,
    super.color,
    super.letterSpacing,
    super.height,
    super.decoration,
  }) : super(fontFamily: AppConstants.fontFamilyMontserrat);
}

class PoppinsTextStyle extends TextStyle {
  const PoppinsTextStyle({
    super.fontSize,
    super.fontWeight,
    super.fontStyle,
    super.color,
    super.letterSpacing,
    super.height,
    super.decoration,
  }) : super(fontFamily: AppConstants.fontFamilyPoppins);
}

class AppTextStyles {
  const AppTextStyles._();

  // MONTSERRAT
  static TextStyle moFont20BlackWh400 = MontserratTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle moFont20BlackWh500 = MontserratTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle moFont20BlackWh600 = MontserratTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle moFont20BlackWh700 = MontserratTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
  );

  static TextStyle moFont20BlackWh800 = MontserratTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w800,
  );

  // POPPINS
  static TextStyle poFont20BlackWh400 = PoppinsTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
  );

  static TextStyle poFont20BlackWh500 = PoppinsTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle poFont20BlackWh600 = PoppinsTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static TextStyle poFont20BlackWh700 = PoppinsTextStyle(
    fontSize: 20,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
  );
}
