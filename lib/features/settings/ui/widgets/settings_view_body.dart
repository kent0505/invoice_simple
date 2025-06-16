import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_clients_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/add_item_view.dart';
import 'package:invoice_simple/features/settings/ui/screens/business_view.dart';
import 'package:invoice_simple/features/settings/ui/widgets/settings_tile.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingHorizontal,
          vertical: 10,
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 26,
            right: 26,
            top: 75,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SettingsTile(
                title: "Business Information",
                onTap: () {
                  context.push(BusinessView.routeName);
                },
              ),
              SettingsTile(
                title: "Clients",
                onTap: () {
                  context.push(AddClientsView.routeName);
                },
              ),
              SettingsTile(
                title: "Items",
                onTap: () {
                  context.push(AddItemView.routeName);
                },
              ),
              SettingsTile(isHaveIcon: false, title: "Privacy", onTap: () {}),
              SettingsTile(isHaveIcon: false, title: "Terms", onTap: () {}),
              SettingsTile(isHaveIcon: false, title: "Contact", onTap: () {}),
              SettingsTile(isHaveIcon: false, title: "Rate App", onTap: () {}),
              SettingsTile(isHaveIcon: false, title: "Share App", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
