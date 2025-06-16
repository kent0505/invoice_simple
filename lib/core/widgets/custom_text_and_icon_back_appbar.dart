import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class CustomTextAndIconBackAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomTextAndIconBackAppbar({
    super.key,
    required this.title,
    required this.onAction,
    required this.actionIcon,
  });

  final String title;
  final VoidCallback onAction;
  final IconData actionIcon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        color: AppColors.background,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        title,
        style: AppTextStyles.poFont20BlackWh600.copyWith(
          fontSize: 16,
          color: AppColors.lightTextColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            actionIcon,
            color: AppColors.black,
          ),
          onPressed: onAction,
        ),
      ],
    );
  }
}
