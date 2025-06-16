import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';

class InvoiceDetailsViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const InvoiceDetailsViewAppBar({
    super.key,
    this.onMorePressed,
  });

  final VoidCallback? onMorePressed;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      leading: Button(
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Row(
          children: [
            Text(
              'Preview',
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: 10),
            Button(
              onPressed: onMorePressed,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: AppColors.black),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.black,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
      // This keeps the color fixed even when scrolling
      flexibleSpace: Container(
        color: AppColors.background,
      ),
    );
  }
}
