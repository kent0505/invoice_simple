import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/helpers/shared_pref_helper.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/build_message_bar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/business_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/client_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/items_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/inoice_preview_view.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/invoice_details_view.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/add_row_button.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_select_item.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_header_row.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/new_invoice_add_photo.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/section_label.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/summary_row.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_clients_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_item_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/business_view.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NewInvoiceViewBody extends StatefulWidget {
  const NewInvoiceViewBody({super.key, required this.isEstimate});
  final bool isEstimate;
  @override
  State<NewInvoiceViewBody> createState() => NewInvoiceViewBodyState();
}

class NewInvoiceViewBodyState extends State<NewInvoiceViewBody> {
  int invoiceNumber = 1;
  File? logoImage;
  BusinessUserModel? get selectedBusiness =>
      context.read<BusinessCubit>().state.selectedBusiness;

  ClientModel? get selectedClient =>
      context.read<ClientCubit>().state.selectedClient;

  List<ItemModel> get selectedItems =>
      context.read<ItemsCubit>().state.selectedItems;

  double get totalAmount => context.read<ItemsCubit>().state.totalAmount;

  String get currency => context.read<BusinessCubit>().state.currency;

  void onPreview() {
    if (selectedBusiness == null ||
        selectedClient == null ||
        selectedItems.isEmpty) {
      buildMessageBar(
        context,
        "Please fill all business Account , Client and Items.",
      );
      return;
    }

    context.push(
      InvoicePreviewView.routeName,
      extra: InvoiceModel(
        issuedDate: DateTime.now(),
        invoiceNumber: invoiceNumber,
        businessAccount: selectedBusiness!,
        client: selectedClient!,
        items: selectedItems,
        total: totalAmount,
        currency: currency,
        imagePath: logoImage?.path ?? '',
      ),
    );
  }

  void onDone() {
    _saveInvoiceData();
  }

  @override
  void initState() {
    super.initState();
    _loadInvoiceData();
  }

  Future<void> _loadInvoiceData() async {
    int count = await SharedPrefHelper.getInt(AppConstants.prefsInvoiceNumber);
    if (count == 0) {
      count = 1;
    }

    if (mounted) {
      setState(() {
        invoiceNumber = count;
      });
    }
  }

  void _saveInvoiceData() async {
    // ✅ Using values from Cubits
    if (selectedBusiness == null ||
        selectedClient == null ||
        selectedItems.isEmpty) {
      buildMessageBar(
        context,
        "Please fill all business Account , Client and Items.",
      );
      return;
    }

    final box = await Hive.openBox<InvoiceModel>(AppConstants.hiveInvoiceBox);

    final invoiceCalculationResult = calculateInvoiceTotals(selectedItems);
    final newInvoice = InvoiceModel(
      issuedDate: DateTime.now(),
      invoiceNumber: invoiceNumber,
      businessAccount: selectedBusiness!,
      client: selectedClient!,
      items: selectedItems,
      total: totalAmount, // ✅ From Cubit
      currency: currency, // ✅ From Cubit
      imagePath: logoImage?.path ?? '',
      isEstimated: widget.isEstimate,
      invoiceDiscount: invoiceCalculationResult.totalDiscount,
      invoiceTax: invoiceCalculationResult.totalTax,
      invoiceSubtotal: invoiceCalculationResult.subtotal,
      invoiceTotal: invoiceCalculationResult.total,
    );

    await box.add(newInvoice);
    SharedPrefHelper.setData(
      AppConstants.prefsInvoiceNumber,
      invoiceNumber + 1,
    );
    if (mounted) {
      buildMessageBar(context, "Invoice saved successfully!");
      context.pushReplacement(
        InvoiceDetailsView.routeName,
        extra: newInvoice,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                "New invoice",
                style: AppTextStyles.poFont20BlackWh600.copyWith(
                  fontSize: 26,
                  color: AppColors.lightTextColor,
                ),
              ),
            ),
            SizedBox(height: 40),

            InvoiceHeaderRow(
                issued: DateFormat("d MMM yyyy").format(DateTime.now()),
                due: "-",
                number: invoiceNumber.toString().padLeft(3, '0')),
            SizedBox(height: 18),

            // Business Account
            SectionLabel(label: 'Business account'),
            BlocBuilder<BusinessCubit, BusinessState>(
              builder: (context, state) {
                if (state.selectedBusiness == null) {
                  return AddRowButton(
                    text: "Choose Account",
                    onTap: () async {
                      final cubit = context.read<BusinessCubit>();
                      final business = await context.push<BusinessUserModel>(
                        BusinessView.routeName,
                        extra: true,
                      );

                      if (business != null) {
                        cubit.selectBusiness(business);
                      }
                    },
                  );
                } else {
                  return CustomSelectItem(
                    text: state.selectedBusiness!.name,
                    onPressed: () {
                      context.read<BusinessCubit>().clearBusiness();
                    },
                  );
                }
              },
            ),

            SizedBox(height: 10),

            // Client
            SectionLabel(label: 'Client'),
            BlocBuilder<ClientCubit, ClientState>(
              builder: (context, state) {
                if (state.selectedClient == null) {
                  return AddRowButton(
                    text: "Add Client",
                    onTap: () async {
                      final cubit = context.read<ClientCubit>();
                      final client = await context.push<ClientModel>(
                        AddClientsView.routeName,
                        extra: true,
                      );

                      if (client != null) {
                        cubit.selectClient(client);
                      }
                    },
                  );
                } else {
                  return CustomSelectItem(
                    text: state.selectedClient!.clientName,
                    onPressed: () {
                      context.read<ClientCubit>().clearClient();
                    },
                  );
                }
              },
            ),
            SizedBox(height: 10),

            // Items
            SectionLabel(label: 'Items'),
            BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                if (state.selectedItems.isEmpty) {
                  return AddRowButton(
                    text: "Add Items",
                    onTap: () async {
                      final cubit = context.read<ItemsCubit>();

                      final selectedItems = await context.push<List<ItemModel>>(
                        AddItemView.routeName,
                        extra: true, // clickable = true
                      );

                      if (selectedItems != null && selectedItems.isNotEmpty) {
                        cubit.addItems(selectedItems);
                      }
                    },
                  );
                } else {
                  return Column(
                    children: [
                      // Display selected items
                      Column(
                        children: state.selectedItems.map((item) {
                          return CustomSelectItem(
                            text: item.name ?? 'Unknown Item',
                            onPressed: () {
                              context.read<ItemsCubit>().removeItem(item);
                            },
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 10),

                      // Add another items button
                      AddRowButton(
                        text: "Add another Items",
                        onTap: () async {
                          final cubit = context.read<ItemsCubit>();
                          cubit.clearAllItems();

                          final selectedItems =
                              await context.push<List<ItemModel>>(
                            AddItemView.routeName,
                            extra: true, // clickable = true
                          );

                          if (selectedItems != null &&
                              selectedItems.isNotEmpty) {
                            cubit.addItems(selectedItems);
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),

            SizedBox(height: 14),

            // Summary
            SectionLabel(label: 'Summary'),
            BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, itemsState) {
                return BlocBuilder<BusinessCubit, BusinessState>(
                  builder: (context, businessState) {
                    return SummaryRow(
                      currency: businessState.currency,
                      totalAmount: itemsState.totalAmount,
                    );
                  },
                );
              },
            ),

            SizedBox(height: 14),

            // Photos
            SectionLabel(label: 'Photos'),
            NewInvoiceAddPhoto(
              onImageSelected: (image) {
                setState(() {
                  logoImage = image;
                });
              },
            ),

            SizedBox(height: 50),

            // Action Buttons
            FilledTextButton(
              text: "Create New Invoice",
              onPressed: _saveInvoiceData,
            ),

            SizedBox(height: 68),
          ],
        ),
      ),
    );
  }
}
