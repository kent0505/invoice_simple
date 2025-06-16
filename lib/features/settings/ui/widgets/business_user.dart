import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/ui/widgets/more_menu.dart';

class BusinessUser extends StatelessWidget {
  final BusinessUserModel user;
  const BusinessUser({
    super.key, required this.user, required this.clickable,
   
  });
  final bool clickable;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: clickable ? () {
      context.pop(user);
      
      } : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Avatar
        Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
        ),
        child: user.imageLogo != null
        ? ClipOval(
      child: Image.file(
        File(user.imageLogo!),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
        )
        : const Icon(Icons.person, color: AppColors.white, size: 32),
      ),
            const SizedBox(width: 14),
            // Name and Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.poFont20BlackWh600.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email??"",
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            // More icon with custom popup menu
            MoreMenu(
               onDelete: () async {
         
      await user.delete();
      
        } 
            ),
          ],
        ),
      ),
    );
  }
}
