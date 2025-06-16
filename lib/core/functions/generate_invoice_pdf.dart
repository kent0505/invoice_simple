import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/functions/load_and_validate_images.dart';
import 'package:invoice_simple/core/utils.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

Future<void> printInvoice(InvoiceModel invoice, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CupertinoActivityIndicator(radius: 18),
    ),
  );

  try {
    final pdfBytes = await generateInvoicePdfBytes(invoice);

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  } catch (e) {
    logger('Error generating or printing PDF: $e');
  } finally {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

Future<void> shareInvoice(InvoiceModel invoice, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CupertinoActivityIndicator(radius: 18),
    ),
  );

  try {
    final pdfBytes = await generateInvoicePdfBytes(invoice);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/invoice.pdf');

    await file.writeAsBytes(pdfBytes);

    final params = ShareParams(
      text: 'Here is your invoice PDF',
      files: [XFile(file.path)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      logger('Thank you for sharing the PDF!');
    } else {
      logger('Sharing failed or was cancelled.');
    }
  } catch (e) {
    logger('Error generating or sharing PDF: $e');
  } finally {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

Future<Uint8List> generateInvoicePdfBytes(InvoiceModel invoice) async {
  final images = await loadAndValidateImages(invoice);
  final signatureBytes = images['signature'];
  final invoiceBytes = images['invoice'];

  String? title = (invoice.isEstimated ?? false) ? 'ESTIMATE' : 'INVOICE';
  final pdf = pw.Document();

  final totals = calculateInvoiceTotals(invoice.items);
  double subtotal = invoice.invoiceSubtotal ?? totals.subtotal;
  double totalDiscount = invoice.invoiceDiscount ?? totals.totalDiscount;
  double totalTax = invoice.invoiceTax ?? totals.totalTax;
  final total = invoice.invoiceTotal ?? totals.total;
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

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 23),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        title,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        DateFormat('d MMMM yyyy').format(invoice.issuedDate),
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'INVOICE NO ${invoice.invoiceNumber.toString()}',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                    ],
                  ),
                ),
                pw.SizedBox(height: 80),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // INVOICE TO (Client)
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'INVOICE TO:',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            invoice.client.clientName,
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            invoice.client
                                .billTo, // or job title if you have it separately
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            'Phone: ${invoice.client.clientPhone}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            'Email: ${invoice.client.clientEmail}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // INVOICE FROM (Business)
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'INVOICE FROM:',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            invoice.businessAccount.name,
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            invoice.businessAccount.address ?? '',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            'Phone: ${invoice.businessAccount.phone ?? ""}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            'Email: ${invoice.businessAccount.email ?? ""}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 46),
                pw.Container(
                  height: 32,
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          "No",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.left,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Product",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.left,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          "Product Description",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.left,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Price",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Quantity",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          "Total",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                ...invoice.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final qty = item.quantity ?? 0;
                  final price = item.unitPrice ?? 0;
                  final amount = qty * price;
                  final number = (index + 1).toString().padLeft(2, '0');

                  return pw.Container(
                    height: 44,
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            number,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.normal,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            item.name ?? '',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.normal,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Expanded(
                          flex: 5,
                          child: pw.Text(
                            item.details ?? '',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.normal,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: pw.TextStyle(fontSize: 14),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            qty.toString(),
                            style: pw.TextStyle(fontSize: 14),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: pw.TextStyle(fontSize: 14),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                pw.SizedBox(height: 50),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // LEFT: Payment Method details
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Payment Method:${invoice.paymentMethod} ',
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Account No:   ',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              pw.Text(
                                '',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Account Name:   ',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              pw.Text(
                                '',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Branch Name:   ',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              pw.Text(
                                '',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Spacer(flex: 2),

                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Subtotal: ',
                                  style: pw.TextStyle(fontSize: 10)),
                              pw.Text('\$${subtotal.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Discount: ',
                                  style: pw.TextStyle(fontSize: 10)),
                              pw.Text('\$${totalDiscount.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Tax: ',
                                  style: pw.TextStyle(fontSize: 10)),
                              pw.Text('\$${totalTax.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Total: ',
                                  style: pw.TextStyle(fontSize: 13)),
                              pw.Text('\$${total.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 13)),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Amount paid: ',
                                  style: pw.TextStyle(fontSize: 10)),
                              pw.Text('\$${amountPaid.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 13)),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Balance Due: ',
                                  style: pw.TextStyle(fontSize: 10)),
                              pw.Text('\$${balanceDue.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                pw.SizedBox(height: 50),
                buildImagesRow(signatureBytes, invoiceBytes),
                pw.SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    ),
  );
  return pdf.save();
}
