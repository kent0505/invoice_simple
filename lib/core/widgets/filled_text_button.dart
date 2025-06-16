import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';

class FilledTextButton extends StatelessWidget {
  const FilledTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Button(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.moFont20BlackWh400.copyWith(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
