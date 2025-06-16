import 'package:flutter/material.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/business_user.dart';


class BusinessViewBody extends StatelessWidget {
  const BusinessViewBody({
    super.key,
    required this.clickable,
    required this.users,
  });
  final bool clickable;
  final List<BusinessUserModel> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_outlined,
                color: Colors.blueAccent,
                size: 68,
              ),
              const SizedBox(height: 24),
              Text(
                "No business accounts yet",
                style: AppTextStyles.poFont20BlackWh500,
                textAlign: TextAlign.center,
              ),
          
         
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => BusinessUser(
         clickable: clickable,
        user: users[index],
      ),
    );
  }
}