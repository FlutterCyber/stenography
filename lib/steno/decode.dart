import 'dart:io';
import 'package:steganograph/steganograph.dart';

class Decode {
  static Future<String?> decode_image_with_message(File file) async {
    String? embeddedMessage = await Steganograph.decode(
      image: file,
    );
    return embeddedMessage;
  }

  static Future<File?> decode_image_with_file(File file) async {
    final embeddedFile = await Steganograph.decodeFile(
      image: file,
    );
    return embeddedFile;
  }
}
