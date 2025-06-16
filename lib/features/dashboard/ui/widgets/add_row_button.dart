import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class AddRowButton extends StatelessWidget {
  const AddRowButton({
    super.key,
    required this.text,
    required this.onTap,
    this.trailing,
  });

  final String text;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circle icon
                  Icon(
                    Icons.add_circle,
                    size: 18,
                    color: AppColors.blueGrey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: AppTextStyles.poFont20BlackWh600.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (trailing != null)
                Positioned(
                  right: 10,
                  child: trailing!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
