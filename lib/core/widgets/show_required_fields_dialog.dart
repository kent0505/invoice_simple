import 'package:flutter/cupertino.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

void showRequiredFieldsDialog(
  BuildContext context,
  String message,
) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        "Attention",
        style: AppTextStyles.poFont20BlackWh600,
      ),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            "OK",
            style: AppTextStyles.poFont20BlackWh600.copyWith(fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
