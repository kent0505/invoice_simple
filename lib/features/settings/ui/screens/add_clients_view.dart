import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/widgets/custom_text_and_icon_back_appbar.dart';
import 'package:invoice_simple/features/settings/ui/widgets/add_clients_view_body.dart';
import 'package:invoice_simple/features/settings/ui/widgets/new_client_bottom_sheet.dart';

class AddClientsView extends StatefulWidget {
  const AddClientsView({
    super.key,
    this.clickable = false,
  });

  final bool clickable;
  static const String routeName = '/add-clients';

  @override
  State<AddClientsView> createState() => _AddClientsViewState();
}

class _AddClientsViewState extends State<AddClientsView> {
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
        title: 'Clients',
        onAction: () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
            ),
            builder: (context) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: NewClientBottomSheet(),
            ),
          );
        },
      ),
      body: AddClientsViewBody(
        clickable: widget.clickable,
        myController: myController,
      ),
    );
  }
}
