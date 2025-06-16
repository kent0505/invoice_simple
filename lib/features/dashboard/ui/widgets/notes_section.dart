import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            "Notes & Payment Instructions",
            style: AppTextStyles.poFont20BlackWh400.copyWith(
              fontSize: 12,
              color: AppColors.blueGrey,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Optional",
              border: InputBorder.none,
            ),
            style: AppTextStyles.poFont20BlackWh400.copyWith(
              fontSize: 12,
              color: AppColors.blueGrey,
            ),
          ),
        )
      ],
    );
  }
}
