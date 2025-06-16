import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      thickness: 0.35,
      color: AppColors.blueGrey,
    );
  }
}
