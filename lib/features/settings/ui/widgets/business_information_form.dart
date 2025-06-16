import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/settings/data/model/currency_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/currency_field.dart';
import 'package:invoice_simple/features/settings/ui/widgets/labeled_text_field.dart';

class BusinessInformationForm extends StatelessWidget {
  final void Function(String?) onChangedName;
  final void Function(String?) onChangedPhone;
  final void Function(String?) onChangedEmail;
  final void Function(String?) onChangedAddress;
  final void Function(CurrencyModel?) onCurrencyChanged;

  const BusinessInformationForm({
    super.key,
    required this.onChangedName,
    required this.onChangedPhone,
    required this.onChangedEmail,
    required this.onChangedAddress,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            "Business Information",
            style: AppTextStyles.moFont20BlackWh400.copyWith(
              color: AppColors.blueGrey,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LabeledTextField(
                label: 'Name',
                onChanged: onChangedName,
                hintText: 'Must be filled',
              ),
              Divider(),
              LabeledTextField(
                label: 'Phone',
                onChanged: onChangedPhone,
                hintText: 'Optional',
                keyboardType: TextInputType.phone,
              ),
              Divider(),
              LabeledTextField(
                label: 'E-Mail',
                onChanged: onChangedEmail,
                hintText: 'Optional',
                keyboardType: TextInputType.emailAddress,
              ),
              Divider(),
              LabeledTextField(
                label: 'Address',
                onChanged: onChangedAddress,
                hintText: 'Optional',
              ),
              Divider(),
              CurrencyField(
                label: "Currency",
                items: currencies,
                onChanged: onCurrencyChanged,
              )
            ],
          ),
        ),
      ],
    );
  }
}
