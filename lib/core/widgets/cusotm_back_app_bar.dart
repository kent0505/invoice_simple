import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/widgets/button.dart';

class CusotmBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CusotmBackAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        color: AppColors.background,
      ),
      leading: Button(
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
