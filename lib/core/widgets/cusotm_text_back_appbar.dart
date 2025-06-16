import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class CusotmTextBackAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CusotmTextBackAppbar({super.key, required this.title});

  final String title;

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
    );
  }
}
