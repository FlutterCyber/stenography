import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CreateFolder {
  static Future<Directory?> messageImageFolder() async {
    Directory? directory;
    Directory? stenoDirectory;
    try {
      if (Platform.isAndroid) {
        stenoDirectory =
            Directory('/storage/emulated/0/Download/steno/message_image/');
      } else if (Platform.isIOS) {
        final myFilesDirectory = await getApplicationDocumentsDirectory();
        stenoDirectory = Directory('${myFilesDirectory!.path}/message_image/');
      }

      if (!(await stenoDirectory!.exists())) {
        await stenoDirectory!.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory!.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> fileImageFolder() async {
    Directory? directory;
    Directory? stenoDirectory;
    try {
      if (Platform.isAndroid) {
        stenoDirectory =
            Directory('/storage/emulated/0/Download/steno/file_image/');
      } else if (Platform.isIOS) {
        final myFilesDirectory = await getApplicationDocumentsDirectory();
        stenoDirectory = Directory('${myFilesDirectory!.path}/file_image/');
      }

      if (!(await stenoDirectory!.exists())) {
        await stenoDirectory!.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory!.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> decodedFileFolder() async {
    Directory? directory;
    Directory? stenoDirectory;
    try {
      if (Platform.isAndroid) {
        stenoDirectory =
            Directory('/storage/emulated/0/Download/steno/decoded_files/');
      } else if (Platform.isIOS) {
        final myFilesDirectory = await getApplicationDocumentsDirectory();
        stenoDirectory = Directory('${myFilesDirectory!.path}/decoded_files/');
      }
      // final myFilesDirectory = await getExternalStorageDirectory();
      // final stenoDirectory = Directory('${myFilesDirectory!.path}/file_image');
      // final stenoDirectory =
      // Directory('/storage/emulated/0/Download/steno/decoded_files');

      if (!(await stenoDirectory!.exists())) {
        await stenoDirectory!.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory!.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> decryptedFileFolder() async {
    Directory? directory;
    Directory? stenoDirectory;
    try {
      // final myFilesDirectory = await getExternalStorageDirectory();
      // final stenoDirectory = Directory('${myFilesDirectory!.path}/file_image');
      // final stenoDirectory =
      // Directory('/storage/emulated/0/Download/steno/decrypted_files');
      if (Platform.isAndroid) {
        stenoDirectory =
            Directory('/storage/emulated/0/Download/steno/decrypted_files/');
      } else if (Platform.isIOS) {
        final myFilesDirectory = await getApplicationDocumentsDirectory();
        stenoDirectory =
            Directory('${myFilesDirectory!.path}/decrypted_files/');
      }

      if (!(await stenoDirectory!.exists())) {
        await stenoDirectory!.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory!.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }
}
