import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/button.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/core/widgets/outlined_text_button.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/invoice_dashboard_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/new_invoice_view.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_filter_button.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_invoice_tile.dart';
import 'package:invoice_simple/features/pro/bloc/pro_bloc.dart';
import 'package:invoice_simple/features/pro/screens/pro_page.dart';
import 'package:invoice_simple/features/pro/screens/pro_sheet.dart';
import 'package:invoice_simple/features/settings/ui/screens/settings_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> invoiceColors = const [
    Color(0xFFB1E5AD), // green
    Color(0xFFE7BDAB), // brown
    Color(0xFFA9ABE5), // violet
    Color(0xFFE2AAE6), // purple
    Color(0xFF8E8E93), // grey
  ];

  final box = Hive.box<InvoiceModel>(AppConstants.hiveInvoiceBox);

  bool _paywallShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProBloc>().state;

      if (!_paywallShown &&
          !state.loading &&
          !state.isPro &&
          state.offering != null &&
          mounted) {
        _paywallShown = true;
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ProSheet.show(
              context,
              identifier: Identifiers.paywall_1,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InvoiceDashboardCubit, int>(
        builder: (context, selectedFilter) {
          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<InvoiceModel> box, _) {
              final inviceList = box.values.toList();

              List<InvoiceModel> filteredList;

              if (selectedFilter == 1) {
                filteredList = inviceList.where((invoice) {
                  final received = invoice.receivedPayment ?? 0;
                  final total = invoice.invoiceTotal ?? 0;
                  final isPaymentMethodEmpty = invoice.paymentMethod == null ||
                      invoice.paymentMethod!.isEmpty;

                  return received < total && isPaymentMethodEmpty;
                }).toList();
              } else if (selectedFilter == 2) {
                // Paid
                filteredList = inviceList.where((invoice) {
                  final received = invoice.receivedPayment ?? 0;
                  final total = invoice.invoiceTotal ?? 0;
                  return received >= total ||
                      invoice.paymentMethod?.isNotEmpty == true;
                }).toList();
              } else {
                filteredList = inviceList;
              }

              double totalIncome = 0;
              for (final invoice in filteredList) {
                totalIncome += getInvoiceTotal(invoice);
              }

              return Column(
                children: [
                  _Total(totalIncome: totalIncome),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      CustomFilterButton(
                        id: 0,
                        label: 'All',
                        selected: selectedFilter == 0,
                      ),
                      const SizedBox(width: 16),
                      CustomFilterButton(
                        id: 1,
                        label: 'Outstanding',
                        selected: selectedFilter == 1,
                      ),
                      const SizedBox(width: 16),
                      CustomFilterButton(
                        id: 2,
                        label: 'Paid',
                        selected: selectedFilter == 2,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 10),
                  filteredList.isEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Center(
                                child: Text(
                                  "No invoice",
                                  style: AppTextStyles.poFont20BlackWh400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(
                              AppConstants.paddingHorizontal,
                            ),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final invoice = filteredList[index];

                              final color =
                                  invoiceColors[index % invoiceColors.length];

                              return CustomInvoiceTile(
                                circleColor: color,
                                invoice: invoice,
                              );
                            },
                          ),
                        ),
                  Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        FilledTextButton(
                          onPressed: () {
                            if (context.read<ProBloc>().state.isPro) {
                              context.push(NewInvoiceView.routeName);
                            } else {
                              context.push(
                                ProPage.routePath,
                                extra: Identifiers.paywall_1,
                              );
                            }
                          },
                          text: "Create Invoice",
                        ),
                        SizedBox(height: 8),
                        OutlinedTextButton(
                          onPressed: () {
                            context.push(
                              NewInvoiceView.routeName,
                              extra: true,
                            );
                          },
                          text: "Create Estimates",
                        ),
                        SizedBox(
                          height: 8 + MediaQuery.of(context).viewPadding.bottom,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.totalIncome});

  final double totalIncome;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ).copyWith(top: 16 + MediaQuery.of(context).viewPadding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Income',
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  '\$${totalIncome.toStringAsFixed(2)}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.moFont20BlackWh800.copyWith(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          Button(
            child: SvgWidget(Assets.imagesSvgSettings),
            onPressed: () {
              context.push(SettingsView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
