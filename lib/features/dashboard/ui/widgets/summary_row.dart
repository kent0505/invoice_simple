import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.currency,
    required this.totalAmount,
  });

  final String currency;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          Text(
            "Total",
            style: AppTextStyles.poFont20BlackWh600.copyWith(
              fontSize: 12,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGrey),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                Text(
                  currency,
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                const Icon(Icons.expand_more, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "$totalAmount \$",
            style: AppTextStyles.poFont20BlackWh600.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
