import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_new_inovice_view_app_bar.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/edit_invoice_view_body.dart';

class EditInvoiceView extends StatelessWidget {
  EditInvoiceView({super.key, required this.invoice});

  final InvoiceModel invoice;
  static const String routeName = '/edit-invoice';

  final GlobalKey<EditInvoiceViewBodyState> bodyKey =
      GlobalKey<EditInvoiceViewBodyState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNewInoviceViewAppBar(
        onPreview: () {
          bodyKey.currentState?.onPreview();
        },
        onDone: () {
          bodyKey.currentState?.onDone();
        },
      ),
      body: EditInvoiceViewBody(
        key: bodyKey,
        invoice: invoice,
      ),
    );
  }
}
