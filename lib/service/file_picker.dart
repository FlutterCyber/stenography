import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PickFile {
  static File? file;

  static Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile platformFile = result.files.first;
        file = File(platformFile.path!);
        
      } else {
      }
    } catch (e) {
      log(e.toString());
    }
    return file;
  }
}
