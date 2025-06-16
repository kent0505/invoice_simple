import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

void buildMessageBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyles.moFont20BlackWh500.copyWith(
          color: Colors.black, // لون النص أسود ليتناسب مع الخلفية البيضاء
          fontSize: 14,
        ),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ), // مسافة من الجوانب وتحت
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ), // padding داخلي
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // حواف دائرية (اختياري)
      ),
      elevation: 6,
    ),
  );
}
