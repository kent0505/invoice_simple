import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';

class SummarySection extends StatefulWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final String currency;
  final ValueChanged<Map<String, double>>? onValuesChanged;

  const SummarySection({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.currency,
    this.onValuesChanged,
  });

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  late TextEditingController subtotalController;
  late TextEditingController discountController;
  late TextEditingController taxController;

  double get totalAmount {
    final subtotal =
        double.tryParse(subtotalController.text.replaceAll(',', '.')) ?? 0;
    final discount =
        double.tryParse(discountController.text.replaceAll(',', '.')) ?? 0;
    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0;

    final afterDiscount = subtotal - discount;
    final afterTax = afterDiscount * (1 - taxPercent / 100);

    return afterTax;
  }

  @override
  void initState() {
    super.initState();
    subtotalController =
        TextEditingController(text: widget.subtotal.toStringAsFixed(2));
    discountController =
        TextEditingController(text: widget.discount.toStringAsFixed(2));
    taxController = TextEditingController(text: widget.tax.toStringAsFixed(2));

    subtotalController.addListener(_onValueChanged);
    discountController.addListener(_onValueChanged);
    taxController.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    setState(() {}); // لتحديث الـ total
    widget.onValuesChanged?.call({
      'subtotal':
          double.tryParse(subtotalController.text.replaceAll(',', '.')) ?? 0,
      'discount':
          double.tryParse(discountController.text.replaceAll(',', '.')) ?? 0,
      'tax': double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0,
      'totalAmount': totalAmount,
    });
  }

  @override
  void dispose() {
    subtotalController.dispose();
    discountController.dispose();
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // AppColors.white
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow("Subtotal", subtotalController),
          Divider(thickness: 0.35, color: AppColors.blueGrey),
          _buildSummaryRow("Discount", discountController),
          Divider(thickness: 0.35, color: AppColors.blueGrey),
          _buildSummaryRow("Tax %", taxController),
          Divider(thickness: 0.35, color: AppColors.blueGrey),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Total",
                  style: AppTextStyles.poFont20BlackWh600.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFB2B1B6)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.currency,
                      style: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.expand_more, size: 18),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${_formatAmount(totalAmount)} \$",
                style: AppTextStyles.poFont20BlackWh600.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.poFont20BlackWh600.copyWith(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 36,
          padding: const EdgeInsets.only(top: 5),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              suffixText: title == "Tax %" ? " %" : ' \$',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTextStyles.poFont20BlackWh600.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _formatAmount(double value) {
    // يفصل كل 3 أرقام ويحط فاصلة عشرية كما بالصورة
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]} ',
    );
    return '$intPart,${parts[1]}';
  }
}
