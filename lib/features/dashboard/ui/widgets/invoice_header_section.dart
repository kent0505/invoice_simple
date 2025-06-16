import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/functions/update_invoice_by_number.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';

enum PaymentMethod { cash, check, bank, paypal }

class InvoiceHeaderSection extends StatefulWidget {
  final bool isPaid;
  final PaymentMethod? paymentMethod;
  final InvoiceModel invoice;

  const InvoiceHeaderSection({
    super.key,
    required this.isPaid,
    this.paymentMethod,
    required this.invoice,
  });

  @override
  State<InvoiceHeaderSection> createState() => _InvoiceHeaderSectionState();
}

class _InvoiceHeaderSectionState extends State<InvoiceHeaderSection> {
  double? receivedPayment;

  double total = 0;

  @override
  void initState() {
    super.initState();
    final invoiceCalculationResult =
        calculateInvoiceTotals(widget.invoice.items);
    total = widget.invoice.invoiceTotal ?? invoiceCalculationResult.total;
    receivedPayment = widget.invoice.receivedPayment;
  }

  void showPaymentDialog(BuildContext context, double? currentValue) {
    final controller = TextEditingController(
      text: currentValue?.toString() ?? '',
    );

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Enter Received Payment',
          style: AppTextStyles.poFont20BlackWh600.copyWith(fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              placeholder: "Payment Amount",
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                fontSize: 14,
                color: AppColors.black,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Cancel',
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Save',
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              final value = double.tryParse(controller.text);
              updateInvoiceByNumber(
                invoiceNumber: widget.invoice.invoiceNumber,
                updatedInvoice: widget.invoice.copyWith(
                  receivedPayment: value ?? 0.0,
                ),
              );
              if (value != null) {
                setState(() {
                  receivedPayment = value;
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String paymentMethodText() {
      switch (widget.paymentMethod) {
        case PaymentMethod.cash:
          return "Cash";
        case PaymentMethod.check:
          return "Check";
        case PaymentMethod.bank:
          return "Bank";
        case PaymentMethod.paypal:
          return "PayPal";
        default:
          return "";
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingHorizontal),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 320,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 0,
                left: 10,
                right: 10,
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      color: AppColors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.invoice.businessAccount.name,
                                      style: AppTextStyles.poFont20BlackWh600
                                          .copyWith(fontSize: 10),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '',
                                      style: AppTextStyles.poFont20BlackWh400
                                          .copyWith(
                                        fontSize: 8,
                                        color: AppColors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      '',
                                      style: AppTextStyles.poFont20BlackWh400
                                          .copyWith(
                                        fontSize: 8,
                                        color: AppColors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'INVOICE',
                                      style: AppTextStyles.poFont20BlackWh600
                                          .copyWith(fontSize: 10),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "#${widget.invoice.invoiceNumber.toString().padLeft(3, '0')}",
                                      style: AppTextStyles.poFont20BlackWh400
                                          .copyWith(
                                        fontSize: 8,
                                        color: AppColors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      'Issued ${DateFormat('dd/MM/yyyy').format(widget.invoice.issuedDate)}',
                                      style: AppTextStyles.poFont20BlackWh400
                                          .copyWith(
                                        fontSize: 8,
                                        color: AppColors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "FROM",
                                  style:
                                      AppTextStyles.poFont20BlackWh600.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "BILL TO",
                                  style:
                                      AppTextStyles.poFont20BlackWh600.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "Ivan Ivanov",
                                  style:
                                      AppTextStyles.poFont20BlackWh600.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .06),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.isPaid && widget.paymentMethod != null
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    "Paid",
                                    style: AppTextStyles.poFont20BlackWh400
                                        .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.blueGrey
                                        .withValues(alpha: .5),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    paymentMethodText(),
                                    style: AppTextStyles.poFont20BlackWh400
                                        .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('MMMM')
                                  .format(widget.invoice.issuedDate),
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                color: AppColors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${total.toStringAsFixed(2)} \$',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Edit to add client',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 16,
                                color: AppColors.blueGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 7),
                            Text(
                              '${total.toStringAsFixed(2)} \$',
                              style: AppTextStyles.poFont20BlackWh600
                                  .copyWith(fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            receivedPayment != null && receivedPayment != 0
                                ? InkWell(
                                    onTap: () => showPaymentDialog(
                                      context,
                                      receivedPayment,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Received Payment: ',
                                          style: AppTextStyles
                                              .poFont20BlackWh400
                                              .copyWith(
                                            fontSize: 14,
                                            color: AppColors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                          ),
                                          child: Text(
                                            '${receivedPayment!.toStringAsFixed(2)} \$',
                                            style: AppTextStyles
                                                .poFont20BlackWh400
                                                .copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.extraLightGreyDivder,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      foregroundColor: AppColors.black,
                                    ),
                                    onPressed: () =>
                                        showPaymentDialog(context, null),
                                    child: Text(
                                      '+ Add Received Payment',
                                      style: AppTextStyles.poFont20BlackWh400
                                          .copyWith(
                                        fontSize: 14,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
