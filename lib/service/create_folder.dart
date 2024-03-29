import 'dart:developer';
import 'dart:io';

class CreateFolder {
  static Directory? directory;

  static Future<Directory?> messageImageFolder() async {
    try {
     // final myFilesDirectory = await getExternalStorageDirectory();
      // final stenoDirectory =
      //     Directory('${myFilesDirectory!.path}/message_image');
      final stenoDirectory =
          Directory('/storage/emulated/0/Download/steno/message_image');

      if (!(await stenoDirectory.exists())) {
        await stenoDirectory.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> fileImageFolder() async {
    try {
      //final myFilesDirectory = await getExternalStorageDirectory();
      //final stenoDirectory = Directory('${myFilesDirectory!.path}/file_image');
      final stenoDirectory =
          Directory('/storage/emulated/0/Download/steno/file_image');

      if (!(await stenoDirectory.exists())) {
        await stenoDirectory.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> decodedFileFolder() async {
    try {
      //final myFilesDirectory = await getExternalStorageDirectory();
      //final stenoDirectory = Directory('${myFilesDirectory!.path}/file_image');
      final stenoDirectory =
      Directory('/storage/emulated/0/Download/steno/decoded_files');

      if (!(await stenoDirectory.exists())) {
        await stenoDirectory.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

  static Future<Directory?> decryptedFileFolder() async {
    try {
      //final myFilesDirectory = await getExternalStorageDirectory();
      //final stenoDirectory = Directory('${myFilesDirectory!.path}/file_image');
      final stenoDirectory =
      Directory('/storage/emulated/0/Download/steno/decrypted_files');

      if (!(await stenoDirectory.exists())) {
        await stenoDirectory.create(recursive: true);
        directory = stenoDirectory;
        log("STENO DIRECTORY CREATED SUCCESSFULLY:: $stenoDirectory");
      } else if (await stenoDirectory.exists()) {
        log("STENO DIRECTORY ALREADY EXIST");
        directory = stenoDirectory;
      }
    } catch (e) {
      log(e.toString());
    }
    return directory;
  }

}
