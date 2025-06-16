import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/invoice_details_view.dart';

class CustomInvoiceTile extends StatelessWidget {
  const CustomInvoiceTile({
    super.key,
    required this.circleColor,
    required this.invoice,
  });

  final Color circleColor;
  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd. yyyy').format(invoice.issuedDate);

    return Container(
      height: 85,
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Button(
        onPressed: () {
          context.push(
            InvoiceDetailsView.routeName,
            extra: invoice,
          );
        },
        child: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: circleColor,
              radius: 28,
              child: Text(
                invoice.client.billTo[0].toUpperCase(),
                style: AppTextStyles.poFont20BlackWh600,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.client.billTo,
                    style: AppTextStyles.poFont20BlackWh600.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (invoice.paymentMethod?.isEmpty ?? true)
                        ? 'Received \$ ${invoice.receivedPayment ?? 0} '
                        : "Invoice Complete",
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formattedDate,
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                fontSize: 12,
                color: Color(0xff748098),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
