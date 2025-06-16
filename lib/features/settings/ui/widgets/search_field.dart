import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.greyLight2,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.greyDark2,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                  fontSize: 17,
                  color: AppColors.greyDark2,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                color: AppColors.greyDark2,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: AppColors.greyDark2,
            ),
          ),
        ],
      ),
    );
  }
}
