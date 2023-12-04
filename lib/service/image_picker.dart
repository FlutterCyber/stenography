import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static File? file;

  static Future<File?> pickImage(imageSource) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        log("Picked file path :: ${pickedFile.path}");

        /// image picker XFile qaytaradi bizga esa File kerak
        /// shuning uchun pastda pickedFile.path yozilgan
        file = File(pickedFile.path);
        log("File runtimeType :: ${file.runtimeType}");
      }
    } catch (e) {
      log(e.toString());
    }
    return file;
  }
}
