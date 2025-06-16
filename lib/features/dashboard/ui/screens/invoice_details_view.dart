import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/functions/generate_invoice_pdf.dart';
import 'package:invoice_simple/core/functions/payment_method_from_string.dart';
import 'package:invoice_simple/core/functions/update_invoice_by_number.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/edit_invoice_view.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/inoice_preview_view.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_details_view_app_bar.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_header_section.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/payment_method.dart';

class InvoiceDetailsView extends StatefulWidget {
  const InvoiceDetailsView({super.key, required this.invoice});

  static const String routeName = '/invoice-details';
  final InvoiceModel invoice;

  @override
  State<InvoiceDetailsView> createState() => _InvoiceDetailsViewState();
}

class _InvoiceDetailsViewState extends State<InvoiceDetailsView> {
  bool isPaid = true;
  PaymentMethod? selectedMethod;

  @override
  void initState() {
    if (widget.invoice.paymentMethod != null &&
        widget.invoice.paymentMethod!.isNotEmpty) {
      selectedMethod = paymentMethodFromString(widget.invoice.paymentMethod!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InvoiceDetailsViewAppBar(
        onMorePressed: () {
          context.push(
            InvoicePreviewView.routeName,
            extra: widget.invoice,
          );
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 176),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InvoiceHeaderSection(
                        invoice: widget.invoice,
                        isPaid: isPaid,
                        paymentMethod: selectedMethod,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingHorizontal,
                        ),
                        child: InvoiceStatusSection(
                          initialPaidDate: widget.invoice.issuedDate,
                          initialPaymentMethod: selectedMethod,
                          onPaymentMethodSelected: (method) async {
                            setState(() {
                              isPaid = true;
                              selectedMethod = method;
                            });

                            await updateInvoiceByNumber(
                              invoiceNumber: widget.invoice.invoiceNumber,
                              updatedInvoice: widget.invoice.copyWith(
                                paymentMethod: paymentMethodText(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInvoiceDetailsSection(widget.invoice),
                      const SizedBox(
                        height: 100,
                      ), // To add extra scroll space if needed
                    ],
                  ),
                ),
              ),

              // Fixed bottom action buttons
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildActionButtonsSection(context, widget.invoice),
              ),
            ],
          );
        },
      ),
    );
  }

  String paymentMethodText() {
    switch (selectedMethod) {
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
}

// Invoice Details Section
Widget _buildInvoiceDetailsSection(InvoiceModel invoice) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingHorizontal),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Issued',
              style: AppTextStyles.poFont20BlackWh400.copyWith(fontSize: 14),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(invoice.issuedDate),
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.blueGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(color: AppColors.extraLightGreyDivder),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invoice #',
              style: AppTextStyles.poFont20BlackWh400.copyWith(fontSize: 14),
            ),
            Text(
              invoice.invoiceNumber.toString().padLeft(3, '0'),
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.blueGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildActionButtonsSection(BuildContext context, InvoiceModel invoice) {
  return Container(
    height: 176,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                shareInvoice(invoice, context);
              },
              child: Column(
                children: [
                  SvgWidget(Assets.imagesSvgShare),
                  Text(
                    'Share',
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                printInvoice(invoice, context);
              },
              child: Column(
                children: [
                  SvgWidget(Assets.imagesSvgPrint),
                  Text(
                    'Print',
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(EditInvoiceView.routeName, extra: invoice);
              },
              child: Column(
                children: [
                  SvgWidget(Assets.imagesSvgEdit),
                  Text(
                    'Edit',
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FilledTextButton(
          onPressed: () {
            showDeleteInvoiceSheet(
              context,
              onDelete: () {
                deleteInvoiceByNumber(invoiceNumber: invoice.invoiceNumber);
                Navigator.pop(context);
              },
            );
          },
          text: "Send Invoice",
        ),
      ],
    ),
  );
}

void showDeleteInvoiceSheet(BuildContext context, {VoidCallback? onDelete}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spacer for rounded effect
            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onDelete != null) onDelete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: Color(0xFFFF0000),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Delete Invoice",
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    color: Color(0xFFFF0000),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: Color(0xFF94A3B8),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: AppTextStyles.poFont20BlackWh600.copyWith(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
