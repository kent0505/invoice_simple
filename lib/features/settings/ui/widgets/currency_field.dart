import 'package:flutter/material.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';
import 'package:invoice_simple/features/settings/data/model/currency_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/currency_bottom_sheet.dart';

class CurrencyField extends StatefulWidget {
  const CurrencyField({
    required this.label,
    required this.items,
    this.onChanged,
    super.key,
  });

  final String label;
  final List<CurrencyModel> items;
  final void Function(CurrencyModel)? onChanged;

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late CurrencyModel selectedCurrency;

  @override
  void initState() {
    super.initState();
    // Default value is "Dollar USA"
    selectedCurrency = widget.items.firstWhere(
      (c) => c.code == "USD",
      orElse: () => widget.items.first,
    );
  }

  void _showCurrencySheet() async {
    final CurrencyModel? result = await showModalBottomSheet<CurrencyModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        minWidth: MediaQuery.of(context).size.width,
      ),
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CurrencyBottomSheet(
          items: widget.items,
          selected: selectedCurrency,
        ),
      ),
    );
    if (result != null && result.code != selectedCurrency.code) {
      setState(() => selectedCurrency = result);
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  widget.label,
                  style: AppTextStyles.moFont20BlackWh400.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: _showCurrencySheet,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedCurrency.name,
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              color: AppColors.extraLightGreyFont,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        SvgWidget(Assets.imagesSvgDrobDown),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
