import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Picks image from gallery and returns a File, or null if canceled.
  static Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
