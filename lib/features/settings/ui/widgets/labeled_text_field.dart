import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.hintText,
    this.keyboardType,
    this.controller,
  });

  final String label;
  final void Function(String?) onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              maxLines: 1,
              style: AppTextStyles.moFont20BlackWh400.copyWith(
                color: AppColors.black,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: AppColors.blueAccent,
              onChanged: onChanged,
              keyboardType: keyboardType,
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.blueAccent,
                fontSize: 17,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                  color: AppColors.extraLightGreyFont,
                  fontSize: 17,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
