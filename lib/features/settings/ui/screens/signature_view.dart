import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:invoice_simple/core/helpers/app_constants.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/widgets/cusotm_text_back_appbar.dart';
import 'package:invoice_simple/core/widgets/filled_text_button.dart';
import 'package:signature/signature.dart';

class SignatureView extends StatelessWidget {
  const SignatureView({super.key, required this.onSaved});

  static const String routeName = '/signatureView';

  final Function(String path) onSaved;
  @override
  Widget build(BuildContext context) {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CusotmTextBackAppbar(title: "Create a Signature"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.paddingHorizontal,
          ),
          child: Column(
            children: [
              Container(
                height: 330,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(color: AppColors.white),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  color: AppColors.lightBlue,
                  dashPattern: const [4, 4],
                  strokeWidth: 1,
                  child: Signature(
                    controller: controller,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 12),
              FilledTextButton(
                onPressed: () async {
                  if (controller.isNotEmpty) {
                    final Uint8List? signature = await controller.toPngBytes();
                    if (signature != null) {
                      final dir = await getApplicationDocumentsDirectory();
                      final filePath =
                          '${dir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
                      final file = File(filePath);
                      await file.writeAsBytes(signature);

                      onSaved(filePath); // callback

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                text: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
