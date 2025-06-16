import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_invoice_preview_app_bar.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_preview_view_body.dart';

class InvoicePreviewView extends StatelessWidget {
  const InvoicePreviewView({super.key, required this.invoice});

  final InvoiceModel invoice;
  static const String routeName = '/invoice-preview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomInvoicePreviewAppBar(),
      body: InvoicePreviewViewBody(
        invoice: invoice,
      ),
    );
  }
}
