import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_table_row.dart';

class InvoicePreviewViewBody extends StatelessWidget {
  const InvoicePreviewViewBody({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final invoiceCalculationResult = calculateInvoiceTotals(invoice.items);
    double subtotal =
        invoice.invoiceSubtotal ?? invoiceCalculationResult.subtotal;
    double totalDiscount =
        invoice.invoiceDiscount ?? invoiceCalculationResult.totalDiscount;
    double totalTax = invoice.invoiceTax ?? invoiceCalculationResult.totalTax;
    final total = invoice.invoiceTotal ?? invoiceCalculationResult.total;
    double amountPaid = 0;
    if (invoice.paymentMethod == null || invoice.paymentMethod!.isEmpty) {
      amountPaid = invoice.receivedPayment ?? 0.0;
    } else {
      amountPaid = total;
    }

    double balanceDue = total - amountPaid;
    if (balanceDue < 0) {
      balanceDue = 0.0;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (invoice.isEstimated ?? false) ? 'ESTIMATE' : 'INVOICE',
                        style: AppTextStyles.poFont20BlackWh700.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat('d MMMM yyyy').format(invoice.issuedDate),
                        style: AppTextStyles.poFont20BlackWh400.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'INVOICE NO ${invoice.invoiceNumber.toString()}',
                        style: AppTextStyles.poFont20BlackWh700.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // INVOICE TO (Client)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INVOICE TO:',
                            style: AppTextStyles.poFont20BlackWh700.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            invoice.client.clientName,
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            invoice.client.billTo,
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Phone: ${invoice.client.clientPhone}',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Email: ${invoice.client.clientEmail}',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // INVOICE FROM (Business)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'INVOICE FROM:',
                            style: AppTextStyles.poFont20BlackWh700.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            invoice.businessAccount.name,
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            invoice.businessAccount.address ?? '',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Phone: ${invoice.businessAccount.phone ?? ""}',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Email: ${invoice.businessAccount.email ?? ""}',
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Table Header
                InvoiceTableRow(
                  backgroundColor: AppColors.extraLightGrey,
                  height: 44,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Name",
                          style: AppTextStyles.poFont20BlackWh600.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "QTY",
                      style: AppTextStyles.poFont20BlackWh600.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "Price, ${invoice.currency}",
                      style: AppTextStyles.poFont20BlackWh600.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "Amount, ${invoice.currency}",
                      style: AppTextStyles.poFont20BlackWh600.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                // Table Content
                Column(
                  children: invoice.items.map((item) {
                    final qty = item.quantity ?? 0;
                    final price = item.unitPrice ?? 0.0;
                    final amount = qty * price;

                    return InvoiceTableRow(
                      height: 44,
                      showBottomBorder: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Text(
                          qty.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          price.toStringAsFixed(2),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          amount.toStringAsFixed(2),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Total Row
                Row(
                  children: [
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Subtotal: ',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${subtotal.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Discount: ',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${totalDiscount.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Tax: ',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${totalTax.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Total: ',
                              style: AppTextStyles.poFont20BlackWh700.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh700.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Amount paid: ',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${amountPaid.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Balance Due: ',
                              style: AppTextStyles.poFont20BlackWh700.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '\$${balanceDue.toStringAsFixed(2)}',
                              style: AppTextStyles.poFont20BlackWh700.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                buildImagesRowNormal(
                  context,
                  invoice.businessAccount.imageSignature,
                  invoice.imagePath,
                ),

                const SizedBox(height: 80),
              ],
            )),
      ),
    );
  }
}

Widget buildImagesRowNormal(
    BuildContext context, String? signaturePath, String? invoicePath) {
  if ((signaturePath == null || signaturePath.isEmpty) &&
      (invoicePath == null || invoicePath.isEmpty)) {
    return SizedBox.shrink();
  }

  MainAxisAlignment getMainAxisAlignment() {
    if ((signaturePath != null && signaturePath.isNotEmpty) &&
        (invoicePath != null && invoicePath.isNotEmpty)) {
      return MainAxisAlignment.spaceBetween;
    } else if (signaturePath != null && signaturePath.isNotEmpty) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }

  return Container(
    margin: EdgeInsets.symmetric(vertical: 50),
    child: Row(
      mainAxisAlignment: getMainAxisAlignment(),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (invoicePath != null && invoicePath.isNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice Image:',
                style: AppTextStyles.poFont20BlackWh700.copyWith(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Image.file(
                File(invoicePath),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 150,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
        if (signaturePath != null && signaturePath.isNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Signature:',
                  style: AppTextStyles.poFont20BlackWh700.copyWith(
                    fontSize: 15,
                  )),
              Text(
                '_______________',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 5),
              Image.file(
                File(signaturePath),
                width: 80,
                height: 50,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ],
    ),
  );
}
