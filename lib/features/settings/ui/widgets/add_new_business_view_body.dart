import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/build_message_bar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:invoice_simple/features/settings/data/model/business_user_model.dart';
import 'package:invoice_simple/features/settings/ui/screens/signature_view.dart';
import 'package:invoice_simple/features/settings/ui/widgets/add_logo_widget.dart';
import 'package:invoice_simple/features/settings/ui/widgets/business_information_form.dart';

class AddNewBusinessViewBody extends StatefulWidget {
  const AddNewBusinessViewBody({super.key});

  @override
  State<AddNewBusinessViewBody> createState() => _AddNewBusinessViewBodyState();
}

class _AddNewBusinessViewBodyState extends State<AddNewBusinessViewBody> {
  String selectedCurrency = "USA";
  String businessName = "",
      businessPhone = "",
      businessEmail = "",
      businessAddress = "";
  File? logoImage;
  String? signaturePath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.paddingHorizontal,
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            AddLogoWidget(
              onImageSelected: (image) {
                setState(() {
                  logoImage = image;
                });
              },
            ),
            SizedBox(height: 32),
            BusinessInformationForm(
              onChangedName: (val) {
                setState(() {});
                businessName = val ?? "";
              },
              onChangedPhone: (val) {
                businessPhone = val ?? "";
              },
              onChangedEmail: (val) {
                businessEmail = val ?? "";
              },
              onChangedAddress: (val) {
                businessAddress = val ?? "";
              },
              onCurrencyChanged: (val) {
                selectedCurrency = val?.code ?? "";
              },
            ),
            SizedBox(height: 20),
            Text(
              signaturePath != null
                  ? "Signature saved ✅"
                  : "You have no signature now",
              style: AppTextStyles.moFont20BlackWh600.copyWith(
                fontSize: 16,
                color: AppColors.lightTextColor,
              ),
            ),
            SizedBox(height: 12),
            FilledTextButton(
              onPressed: () {
                context.push(
                  SignatureView.routeName,
                  extra: (String path) {
                    setState(() {
                      signaturePath = path;
                    });
                  },
                );
              },
              color: signaturePath != null ? null : AppColors.blue,
              text: signaturePath != null
                  ? "Create a Signature another"
                  : "Create a Signature",
            ),
            SizedBox(height: 10),
            FilledTextButton(
              color: businessName != "" ? null : AppColors.blue,
              onPressed: () {
                if (businessName != "") {
                  saveBusinessData(
                    businessName: businessName,
                    context: context,
                    businessPhone: businessPhone,
                    businessEmail: businessEmail,
                    businessAddress: businessAddress,
                    selectedCurrency: selectedCurrency,
                    imageLogo: logoImage?.path,
                    signaturePath: signaturePath,
                  );
                } else {
                  buildMessageBar(context, "Please fill in name field");
                }
              },
              text: "Save Business Account",
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void saveBusinessData({
    required String businessName,
    required BuildContext context,
    required String businessPhone,
    required String businessEmail,
    required String businessAddress,
    required String selectedCurrency,
    required String? imageLogo,
    required String? signaturePath,
  }) {
    var box = Hive.box<BusinessUserModel>(
      AppConstants.hiveBusinessBox,
    );

    bool isExists = box.values.any(
      (element) => element.name == businessName,
    );

    if (isExists) {
      buildMessageBar(
        context,
        "Business with same name already exists!",
      );
    } else {
      var newBusiness = BusinessUserModel(
        name: businessName,
        phone: businessPhone,
        email: businessEmail,
        address: businessAddress,
        currency: selectedCurrency,
        imageLogo: imageLogo,
        imageSignature: signaturePath, // add this to your model
      );

      box.add(newBusiness);

      for (var business in box.values) {
        debugPrint(
          'Business: ${business.name}, Phone: ${business.phone}, Email: ${business.email}, Address: ${business.address}, Currency: ${business.currency}, Signature: ${business.imageSignature} , Logo: ${business.imageLogo}',
        );
      }
      context.pop();
    }
  }
}
