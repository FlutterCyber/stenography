import 'dart:developer';
import 'dart:io';
import 'package:steganograph/steganograph.dart';

import '../service/create_folder.dart';

class Encode {
  static File? encodedImage;

  static hideMessageInImage(
      {required File image, required String secretMessage}) async {
    Directory? stenoDirectory = await CreateFolder.messageImageFolder();

    try {
      encodedImage = await Steganograph.encode(
        image: image,
        message: secretMessage,
        outputFilePath: stenoDirectory.toString(),
      );
      log("Message encoding success");
    } catch (e) {
      log("MESSAGE ENCODING ERROR:: $e");
    }
    return encodedImage;
  }

  static hideFileInImage({required File image, required File file}) async {
    Directory? stenoDirectory = await CreateFolder.fileImageFolder();

    try {
      encodedImage = await Steganograph.encodeFile(
        image: image,
        fileToEmbed: file,
        outputFilePath: stenoDirectory.toString(),
      );
      log("FILE ENCODE SUCCESS");
    } catch (e) {
      log("FILE ENCODE ERROR:: $e");
    }
    return encodedImage;
  }
}
