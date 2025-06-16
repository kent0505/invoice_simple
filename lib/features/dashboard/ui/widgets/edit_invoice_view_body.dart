import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_simple/core/functions/get_invoice_total.dart';
import 'package:invoice_simple/core/functions/update_invoice_by_number.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/build_message_bar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/features/dashboard/data/models/invoice_model.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/client_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/cubit/items_cubit.dart';
import 'package:invoice_simple/features/dashboard/ui/screens/inoice_preview_view.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/add_row_button.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/custom_select_item.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/invoice_header_row.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/new_invoice_add_photo.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/notes_section.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/section_label.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/summary_section.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/data/model/client_model.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_clients_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_item_view.dart';

class EditInvoiceViewBody extends StatefulWidget {
  const EditInvoiceViewBody({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  State<EditInvoiceViewBody> createState() => EditInvoiceViewBodyState();
}

class EditInvoiceViewBodyState extends State<EditInvoiceViewBody> {
  late BusinessUserModel businessUserModel;
  TextEditingController notesController = TextEditingController();
  File? logoImage;
  double updatedSubtotal = 0;
  double updatedDiscount = 0;
  double updatedTax = 0;
  double updatedTotalAmount = 0;

  @override
  void initState() {
    super.initState();
    final clientCubit = context.read<ClientCubit>();
    clientCubit.selectClient(widget.invoice.client);
    final itemsCubit = context.read<ItemsCubit>();
    itemsCubit.addItems(widget.invoice.items);
    businessUserModel = widget.invoice.businessAccount;
    notesController.text = widget.invoice.notes ?? '';
    final totals = calculateInvoiceTotals(widget.invoice.items);
    updatedSubtotal = widget.invoice.invoiceSubtotal ?? totals.subtotal;
    updatedDiscount = widget.invoice.invoiceDiscount ?? totals.totalDiscount;
    updatedTax = widget.invoice.invoiceTax ?? totals.totalTax;
    updatedTotalAmount = widget.invoice.invoiceTotal ?? totals.total;
  }

  ClientModel? get selectedClient =>
      context.read<ClientCubit>().state.selectedClient;

  List<ItemModel> get selectedItems =>
      context.read<ItemsCubit>().state.selectedItems;

  double get totalAmount => context.read<ItemsCubit>().state.totalAmount;

  void onPreview() {
    if (selectedClient == null || selectedItems.isEmpty) {
      buildMessageBar(
        context,
        "Please fill all business Account , Client and Items.",
      );
      return;
    }

    context.push(
      InvoicePreviewView.routeName,
      extra: InvoiceModel(
        issuedDate: widget.invoice.issuedDate,
        invoiceNumber: widget.invoice.invoiceNumber,
        businessAccount: businessUserModel,
        client: selectedClient!,
        items: selectedItems,
        total: updatedTotalAmount,
        invoiceTotal: updatedTotalAmount,
        invoiceSubtotal: updatedSubtotal,
        invoiceDiscount: updatedDiscount,
        invoiceTax: updatedTax,
        currency: widget.invoice.currency,
        imagePath: logoImage?.path ?? '',
      ),
    );
  }

  void onDone() {
    _saveInvoiceData();
  }

  void _saveInvoiceData() {
    if (selectedClient == null || selectedItems.isEmpty) {
      buildMessageBar(
        context,
        "Please fill all business Account , Client and Items.",
      );
      return;
    }

    final updatedInvoice = InvoiceModel(
      issuedDate: widget.invoice.issuedDate,
      invoiceNumber: widget.invoice.invoiceNumber,
      businessAccount: businessUserModel,
      client: selectedClient!,
      items: selectedItems,
      total: totalAmount,
      currency: widget.invoice.currency,
      imagePath: logoImage?.path ?? '',
      notes: notesController.text,
      invoiceSubtotal: updatedSubtotal,
      invoiceDiscount: updatedDiscount,
      invoiceTax: updatedTax,
      invoiceTotal: updatedTotalAmount,
    );

    updateInvoiceByNumber(
      invoiceNumber: widget.invoice.invoiceNumber,
      updatedInvoice: updatedInvoice,
    );

    context.pop();
    context.pop();
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
                "Edit invoice",
                style: AppTextStyles.poFont20BlackWh600.copyWith(
                  fontSize: 26,
                  color: AppColors.lightTextColor,
                ),
              ),
            ),
            SizedBox(height: 40),

            InvoiceHeaderRow(
              issued:
                  DateFormat("d MMM yyyy").format(widget.invoice.issuedDate),
              due: "-",
              number: widget.invoice.invoiceNumber.toString().padLeft(3, '0'),
              onIssuedTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.invoice.issuedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors
                              .primary, // Primary color for the date picker
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black,
                        ),
                        dialogTheme: DialogThemeData(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    widget.invoice.issuedDate = pickedDate;
                  });
                }
              },
            ),

            SizedBox(height: 18),

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
                final totals = calculateInvoiceTotals(widget.invoice.items);
                double subtotal =
                    widget.invoice.invoiceSubtotal ?? totals.subtotal;
                double totalDiscount =
                    widget.invoice.invoiceDiscount ?? totals.totalDiscount;
                double totalTax = widget.invoice.invoiceTax ?? totals.totalTax;
                return SummarySection(
                  subtotal: subtotal,
                  discount: totalDiscount,
                  tax: totalTax,
                  currency: widget.invoice.currency,
                  onValuesChanged: (values) {
                    setState(() {
                      if (values['subtotal'] != null &&
                          values['subtotal'] is double &&
                          values['subtotal'] != 0) {
                        updatedSubtotal = values['subtotal']!;
                      }
                      if (values['discount'] != null &&
                          values['discount'] is double &&
                          values['discount'] != 0) {
                        updatedDiscount = values['discount']!;
                      }
                      if (values['tax'] != null &&
                          values['tax'] is double &&
                          values['tax'] != 0) {
                        updatedTax = values['tax']!;
                      }

                      if (values['totalAmount'] != null &&
                          values['totalAmount'] is double &&
                          values['totalAmount'] != 0) {
                        updatedTotalAmount = values['totalAmount']!;
                      }
                    });
                  },
                );
              },
            ),

            SizedBox(height: 14),

            // Photos
            SectionLabel(label: 'Photos'),
            NewInvoiceAddPhoto(
              initialImagePath: widget.invoice.imagePath,
              onImageSelected: (image) {
                setState(() {
                  logoImage = image;
                });
              },
            ),
            SizedBox(height: 20),
            NotesSection(controller: notesController),
            SizedBox(height: 20),

            // Action Buttons
            FilledTextButton(
              color: AppColors.blue,
              text: "Delete Invoice",
              onPressed: () {
                deleteInvoiceByNumber(
                    invoiceNumber: widget.invoice.invoiceNumber);
                context.pop();
                context.pop();
              },
            ),
            SizedBox(height: 8),
            FilledTextButton(
              text: "Save",
              onPressed: () {
                _saveInvoiceData();
              },
            ),
            SizedBox(height: 68),
          ],
        ),
      ),
    );
  }
}
