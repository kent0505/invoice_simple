import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:invoice_simple/core/helpers/app_assets.dart';
import 'package:invoice_simple/core/helpers/image_picker_helper.dart';
import 'package:invoice_simple/core/theme/app_colors.dart';
import 'package:invoice_simple/core/theme/app_text_styles.dart';
import 'package:invoice_simple/core/widgets/svg_widget.dart';
import 'package:invoice_simple/features/dashboard/ui/widgets/add_row_button.dart';

class NewInvoiceAddPhoto extends StatefulWidget {
  const NewInvoiceAddPhoto({
    super.key,
    this.onImageSelected,
    this.initialImagePath,
  });

  final void Function(File image)? onImageSelected;
  final String? initialImagePath;

  @override
  State<NewInvoiceAddPhoto> createState() => _NewInvoiceAddPhotoState();
}

class _NewInvoiceAddPhotoState extends State<NewInvoiceAddPhoto> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null &&
        widget.initialImagePath!.isNotEmpty) {
      final file = File(widget.initialImagePath!);
      if (file.existsSync()) {
        _selectedImage = file;
      }
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      widget.onImageSelected?.call(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _selectedImage == null
        ? AddRowButton(
            text: "Add Photo",
            trailing: Container(
              decoration: BoxDecoration(
                color: AppColors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  SvgWidget(Assets.imagesSvgStar),
                  SizedBox(width: 4),
                  Text(
                    "premium",
                    style: AppTextStyles.poFont20BlackWh400.copyWith(
                      fontSize: 8,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            onTap: _pickImage,
          )
        : GestureDetector(
            onTap: _pickImage,
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
                  child: Image.file(
                    _selectedImage!,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
  }
}
