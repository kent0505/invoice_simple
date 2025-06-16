import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/widgets/cusotm_text_back_appbar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_new_business_view.dart';
import 'package:invoice_simple/features/settings/ui/widgets/business_view_body.dart';

class BusinessView extends StatelessWidget {
  const BusinessView({super.key, this.clickable = false});

  final bool clickable;
  static const String routeName = "/business";

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<BusinessUserModel>(AppConstants.hiveBusinessBox);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CusotmTextBackAppbar(
        title: "Business",
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 38,
          left: 24,
          right: 24,
        ),
        child: FilledTextButton(
          text: "Add New",
          onPressed: () {
            context.push(AddNewBusinessView.routeName);
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<BusinessUserModel> box, _) {
          final users = box.values.toList();

          return BusinessViewBody(
            clickable: clickable,
            users: users,
          );
        },
      ),
    );
  }
}
