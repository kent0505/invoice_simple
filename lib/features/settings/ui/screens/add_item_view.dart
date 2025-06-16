import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/widgets/custom_text_and_icon_back_appbar.dart';
import 'package:invoice_simple/features/settings/ui/widgets/add_item_view_body.dart';
import 'package:invoice_simple/features/settings/ui/widgets/new_item_bottom_sheet.dart';

class AddItemView extends StatefulWidget {
  const AddItemView({super.key, this.clickable = false});

  final bool clickable;
  static const String routeName = '/add-item-view';

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  late TextEditingController myController;

  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomTextAndIconBackAppbar(
        actionIcon: Icons.add,
        title: 'Items',
        onAction: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
            ),
            builder: (context) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: NewItemBottomSheet(),
            ),
          );
        },
      ),
      body: AddItemViewBody(
        clickable: widget.clickable,
        myController: myController,
      ),
    );
  }
}
