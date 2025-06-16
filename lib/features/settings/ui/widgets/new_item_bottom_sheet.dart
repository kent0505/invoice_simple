import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/build_message_bar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/core/widgets/show_required_fields_dialog.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/custom_switch_button.dart';

class NewItemBottomSheet extends StatefulWidget {
  const NewItemBottomSheet({super.key});

  @override
  State<NewItemBottomSheet> createState() => _NewItemBottomSheetState();
}

class _NewItemBottomSheetState extends State<NewItemBottomSheet> {
  bool saveToCatalog = false;
  bool discountActive = false;
  bool taxable = false;

  // Controllers for TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: "1");
  final TextEditingController unitTypeController =
      TextEditingController(text: "Optional");
  final TextEditingController discountController = TextEditingController();
  final TextEditingController taxableController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
    unitTypeController.dispose();
    discountController.dispose();
    taxableController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (nameController.text.trim().isEmpty) {
      showRequiredFieldsDialog(context, "Name is required");
      return;
    }
    String? billTo =
        nameController.text.trim().isEmpty ? null : nameController.text.trim();
    String? details = detailsController.text.trim().isEmpty
        ? null
        : detailsController.text.trim();

    double? unitPrice = double.tryParse(unitPriceController.text.trim());
    int? quantity = int.tryParse(quantityController.text.trim());
    String? unitType = unitTypeController.text.trim().isEmpty
        ? null
        : unitTypeController.text.trim();
    double? discount = double.tryParse(discountController.text.trim());
    double? taxableAmount = double.tryParse(taxableController.text.trim());
    if (taxableAmount != null) {
      taxable = true;
    }
    if (discount != null) {
      discountActive = true;
    }
    final item = ItemModel(
      name: billTo,
      details: details,
      saveToCatalog: saveToCatalog,
      unitPrice: unitPrice,
      quantity: quantity,
      unitType: unitType,
      discount: discount,
      discountActive: discountActive,
      taxable: taxable,
      taxableAmount: taxableAmount,
    );

    final box = await Hive.openBox<ItemModel>(AppConstants.hiveItemBox);
    await box.add(item);

    if (!mounted) return;
    Navigator.of(context).pop();

    buildMessageBar(context, "Item added successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _saveItem();
                  },
                  child: Text(
                    "Done",
                    style: AppTextStyles.poFont20BlackWh600.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New Item",
                style: AppTextStyles.poFont20BlackWh600.copyWith(
                  fontSize: 26,
                ),
              ),
            ),
            SizedBox(height: 23),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      color: AppColors.blueAccent,
                      fontSize: 13,
                    ),
                    cursorColor: AppColors.blueAccent,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'name',
                      hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 13,
                        color: AppColors.extraLightGreyFont,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Divider(
                      height: 0,
                      color: Color(0xFFF3F3F1),
                    ),
                  ),
                  TextField(
                    controller: detailsController,
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      color: AppColors.blueAccent,
                      fontSize: 13,
                    ),
                    cursorColor: AppColors.blueAccent,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: 'Details (e. g. Completed on 1/12)',
                      hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 13,
                        color: AppColors.extraLightGreyFont,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            // Save to catalog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Save to Items catalog",
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 12,
                    color: AppColors.blueGrey,
                  ),
                ),
                CustomSwitchButton(
                  value: saveToCatalog,
                  onChanged: (val) {
                    setState(() {
                      saveToCatalog = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Unit table header
            Column(
              children: [
                // Table header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Unit Price",
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 12,
                            color: AppColors.blueGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Quantity",
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 12,
                            color: AppColors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Unit Type",
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 12,
                            color: AppColors.blueGrey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table row
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: unitPriceController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            prefixText: "\$ ",
                            hintText: "0",
                            hintStyle: AppTextStyles.poFont20BlackWh400
                                .copyWith(fontSize: 12),
                          ),
                          style: AppTextStyles.poFont20BlackWh400.copyWith(
                            fontSize: 13,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: TextField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "1",
                              hintStyle: AppTextStyles.poFont20BlackWh400
                                  .copyWith(fontSize: 12),
                            ),
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 13,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextField(
                              controller: unitTypeController,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "Optional",
                                hintStyle:
                                    AppTextStyles.poFont20BlackWh400.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              style: AppTextStyles.poFont20BlackWh400.copyWith(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Discount",
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 12,
                    color: AppColors.blueGrey,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: discountController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "0",
                        hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      style: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 13,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  CustomSwitchButton(
                    value: discountActive,
                    onChanged: (val) {
                      setState(() {
                        discountActive = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Taxable row
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Taxable?",
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 12,
                    color: AppColors.blueGrey,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: taxableController,
                      decoration: InputDecoration(
                        prefixText: "%",
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "0%",
                        hintStyle: AppTextStyles.poFont20BlackWh400.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      style: AppTextStyles.poFont20BlackWh400.copyWith(
                        fontSize: 13,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  CustomSwitchButton(
                    value: taxable,
                    onChanged: (val) {
                      setState(() {
                        taxable = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FilledTextButton(
              color: nameController.text.trim().isEmpty ? AppColors.blue : null,
              text: "Continue",
              onPressed: () {
                _saveItem();
              },
            ),
            SizedBox(height: 38),
          ],
        ),
      ),
    );
  }
}
