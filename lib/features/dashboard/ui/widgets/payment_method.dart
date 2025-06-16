import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_header_section.dart';

class InvoiceStatusSection extends StatefulWidget {
  const InvoiceStatusSection({
    super.key,
    this.onPaymentMethodSelected,
    this.initialPaymentMethod,
    this.initialPaidDate, // الإضافة هنا
  });

  final void Function(PaymentMethod)? onPaymentMethodSelected;
  final PaymentMethod? initialPaymentMethod;
  final DateTime? initialPaidDate;

  @override
  State<InvoiceStatusSection> createState() => _InvoiceStatusSectionState();
}

class _InvoiceStatusSectionState extends State<InvoiceStatusSection> {
  bool isPaid = false;
  DateTime? paidDate;
  PaymentMethod? selectedMethod;

  @override
  void initState() {
    super.initState();

    if (widget.initialPaymentMethod != null) {
      selectedMethod = widget.initialPaymentMethod;
      isPaid = true;
      paidDate = widget.initialPaidDate ?? DateTime.now();
    }
  }

  void _showMarkAsPaidSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MarkAsPaidBottomSheet(),
    );
    if (result != null) {
      setState(() {
        isPaid = true;
        paidDate = result['date'] as DateTime;
        selectedMethod = result['method'] as PaymentMethod;
      });
      if (widget.onPaymentMethodSelected != null && selectedMethod != null) {
        widget.onPaymentMethodSelected!(selectedMethod!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isPaid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              'Has Invoice Been Paid?',
              style: AppTextStyles.poFont20BlackWh600.copyWith(fontSize: 12),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _showMarkAsPaidSheet();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Mark as Paid',
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Text(
                'Marked as Paid',
                style: AppTextStyles.poFont20BlackWh400.copyWith(
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    _formatDate(paidDate ?? DateTime.now()),
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      color: AppColors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: AppColors.blueGrey,
                  ),
                ],
              ),
            ],
          ),
          Divider(color: AppColors.extraLightGreyDivder),
        ],
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class MarkAsPaidBottomSheet extends StatefulWidget {
  const MarkAsPaidBottomSheet({super.key});

  @override
  State<MarkAsPaidBottomSheet> createState() => _MarkAsPaidBottomSheetState();
}

class _MarkAsPaidBottomSheetState extends State<MarkAsPaidBottomSheet> {
  PaymentMethod? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Mark as Paid",
            style: AppTextStyles.poFont20BlackWh600.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
              style: AppTextStyles.poFont20BlackWh600.copyWith(
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            "Select How You Received the money",
            style: AppTextStyles.poFont20BlackWh400
                .copyWith(fontSize: 12, color: AppColors.lightBlue),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMethodIcon(
                context,
                PaymentMethod.cash,
                Assets.imagesSvgChash,
                "Cash",
              ),
              _buildMethodIcon(
                context,
                PaymentMethod.check,
                Assets.imagesSvgCheck,
                "Check",
              ),
              _buildMethodIcon(
                context,
                PaymentMethod.bank,
                Assets.imagesSvgBank,
                "Bank",
              ),
              _buildMethodIcon(
                context,
                PaymentMethod.paypal,
                Assets.imagesSvgPaypal,
                "PayPal",
              ),
            ],
          ),
          SizedBox(height: 58),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.blueGrey,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMethodIcon(
      BuildContext context, PaymentMethod method, String asset, String label) {
    final isSelected = selectedMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });

        Future.delayed(
          const Duration(milliseconds: 250),
          () {
            if (context.mounted) {
              Navigator.of(context).pop({
                'method': method,
                'date': DateTime(2025, 5, 6),
              });
            }
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .08)
              : AppColors.white,
          border: Border.all(
            color:
                isSelected ? AppColors.primary : AppColors.extraLightGreyDivder,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Center(
              child: SvgWidget(
                asset,
                width: 34,
                height: 34,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
