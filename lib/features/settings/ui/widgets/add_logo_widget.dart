import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/helpers/image_picker_helper.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';

class AddLogoWidget extends StatefulWidget {
  final void Function(File image)? onImageSelected;

  const AddLogoWidget({super.key, this.onImageSelected});

  @override
  State<AddLogoWidget> createState() => _AddLogoWidgetState();
}

class _AddLogoWidgetState extends State<AddLogoWidget> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final image = await ImagePickerHelper.pickImageFromGallery();
        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
          widget.onImageSelected?.call(image);
        }
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.white),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(5),
          color: AppColors.lightBlue,
          dashPattern: const [4, 4],
          strokeWidth: 2,
          child: Center(
            child: _selectedImage == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgWidget(Assets.imagesSvgAddImage),
                      Text(
                        'Add Logo',
                        style: AppTextStyles.poFont20BlackWh400.copyWith(
                          color: AppColors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Image.file(_selectedImage!, height: 50),
          ),
        ),
      ),
    );
  }
}
