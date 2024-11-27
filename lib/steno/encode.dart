import 'dart:developer';
import 'dart:io';
import 'package:steganograph/steganograph.dart';

class Encode {
  static File? encodedImage;

  static hideMessageInImage(
      {required File image, required String secretMessage}) async {
    try {
      encodedImage = await Steganograph.encode(
        image: image,
        message: secretMessage,
      );
      log("Message encoding success");
    } catch (e) {
      log("MESSAGE ENCODING ERROR:: $e");
    }
    return encodedImage;
  }

  static hideFileInImage({required File image, required File file}) async {
    try {
      encodedImage = await Steganograph.encodeFile(
        image: image,
        fileToEmbed: file,
      );

      log("FILE ENCODE SUCCESS ${encodedImage!.path}");
    } catch (e) {
      log("FILE ENCODE ERROR:: $e");
    }
    return encodedImage;
  }
}
