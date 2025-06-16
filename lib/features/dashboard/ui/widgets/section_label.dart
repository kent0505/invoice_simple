import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
      child: Text(
        label,
        style: AppTextStyles.poFont20BlackWh400.copyWith(
          fontSize: 12,
          color: AppColors.blueGrey,
        ),
      ),
    );
  }
}
