import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/invoice_dashboard_cubit.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    super.key,
    required this.id,
    required this.label,
    required this.selected,
  });

  final int id;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
        onPressed: selected
            ? null
            : () {
                context.read<InvoiceDashboardCubit>().selectFilter(id);
              },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : null,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xff94A3B8),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.poFont20BlackWh400.copyWith(
                fontSize: 16,
                color: selected ? Colors.white : const Color(0xff7D81A3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
