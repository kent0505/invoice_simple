import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.onTap,
    this.isHaveIcon = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool isHaveIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: AppTextStyles.poFont20BlackWh400.copyWith(fontSize: 14),
          ),
          trailing: isHaveIcon
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.black,
                  size: 20,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: onTap,
          dense: true,
          minVerticalPadding: 0,
          horizontalTitleGap: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 0),
          child: Divider(
            color: AppColors.lightGrey,
            height: 0,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
