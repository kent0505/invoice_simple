import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';

class OutlinedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OutlinedTextButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.moFont20BlackWh400.copyWith(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
