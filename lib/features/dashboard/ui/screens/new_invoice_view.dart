import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_new_inovice_view_app_bar.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/new_invoice_view_body.dart';

class NewInvoiceView extends StatelessWidget {
  NewInvoiceView({super.key, this.isEstimate = false});

  static const String routeName = '/new-invoice';
  final bool isEstimate;
  final GlobalKey<NewInvoiceViewBodyState> bodyKey =
      GlobalKey<NewInvoiceViewBodyState>();

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
      body: NewInvoiceViewBody(
        key: bodyKey,
        isEstimate: isEstimate,
      ),
    );
  }
}
