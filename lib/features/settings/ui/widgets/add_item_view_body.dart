import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/features/settings/data/model/item_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/search_field.dart';

class AddItemViewBody extends StatefulWidget {
  const AddItemViewBody({
    super.key,
    required this.myController,
    required this.clickable,
  });

  final TextEditingController myController;
  final bool clickable;

  @override
  State<AddItemViewBody> createState() => _AddItemViewBodyState();
}

class _AddItemViewBodyState extends State<AddItemViewBody> {
  String searchText = '';
  List<ItemModel> selectedItems = [];

  void _onSearchChanged() {
    setState(() {
      searchText = widget.myController.text.trim().toLowerCase();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.myController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.myController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingHorizontal,
      ),
      child: Column(
        children: [
          SearchField(
            controller: widget.myController,
            onChanged: (text) {},
          ),
          SizedBox(height: 12),

          // Total Price Display
          ValueListenableBuilder(
            valueListenable:
                Hive.box<ItemModel>(AppConstants.hiveItemBox).listenable(),
            builder: (context, Box<ItemModel> box, _) {
              final items = box.values.toList();
              final filtered = searchText.isEmpty
                  ? items
                  : items
                      .where((item) =>
                          (item.name ?? '')
                              .toLowerCase()
                              .contains(searchText) ||
                          (item.details ?? '')
                              .toLowerCase()
                              .contains(searchText))
                      .toList();

              double total = filtered.fold(
                0.0,
                (sum, item) =>
                    sum + ((item.unitPrice ?? 0) * (item.quantity ?? 1)),
              );

              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${total.toStringAsFixed(2)}\$',
                  style: AppTextStyles.poFont20BlackWh400.copyWith(
                    fontSize: 14,
                    color: AppColors.blueGrey,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 8),
          Container(height: 0.75, color: AppColors.blueGrey),
          SizedBox(height: 20),

          // Items List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<ItemModel>(AppConstants.hiveItemBox).listenable(),
              builder: (context, Box<ItemModel> box, _) {
                final items = box.values.toList();
                final filtered = searchText.isEmpty
                    ? items
                    : items
                        .where((item) =>
                            (item.name ?? '')
                                .toLowerCase()
                                .contains(searchText) ||
                            (item.details ?? '')
                                .toLowerCase()
                                .contains(searchText))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      "No items found.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final isSelected = selectedItems.contains(item);

                    return GestureDetector(
                      onTap: () {
                        if (widget.clickable) {
                          // Multi-selection mode
                          setState(() {
                            if (isSelected) {
                              selectedItems.remove(item);
                            } else {
                              selectedItems.add(item);
                            }
                          });
                        } else {
                          // Single selection mode - return immediately
                          context.pop([item]);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (widget.clickable)
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected ? Colors.green : Colors.grey,
                                ),
                              SizedBox(width: 8),
                              Text(
                                item.name ?? 'No Name',
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyles.poFont20BlackWh400.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${item.quantity ?? 1} x ${item.unitPrice?.toStringAsFixed(2) ?? "0.00"} \$",
                            style: AppTextStyles.poFont20BlackWh400.copyWith(
                              fontSize: 14,
                              color: AppColors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Add Items Button (only in clickable mode)
          if (widget.clickable)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledTextButton(
                    text: "Add items to invoice",
                    onPressed: () {
                      if (selectedItems.isNotEmpty) {
                        context.pop(selectedItems);
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
