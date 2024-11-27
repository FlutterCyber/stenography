import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stenography/service/file_extension_finder.dart';
import 'create_folder.dart';

class ImageSaver {
  Directory? stenoDirectory;

  Future saveImageToLocalFolder(File file, int folderNumber) async {
    try {
      if (folderNumber == 1) {
        stenoDirectory = await CreateFolder.messageImageFolder();
      } else {
        stenoDirectory = await CreateFolder.fileImageFolder();
      }
      // final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
      final String uniqueFileName = formatter.format(now);

      final localFile = File('${stenoDirectory!.path}/$uniqueFileName.png');
      var copiedFile = await file.copy(localFile.path);
      log('Image saved to: ${copiedFile.path}');
      return localFile.path;
    } catch (e) {
      log('Error saving image: $e');
    }
  }

  Future saveDecodedFileToLocalFolder(File file, String decodedFilename) async {
    try {
      stenoDirectory = await CreateFolder.decodedFileFolder();
      //final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
      final String uniqueFileName = formatter.format(now);
      //final String uniqueFileName = formattedDate;

      final localFile = File(
          '${stenoDirectory!.path}/$uniqueFileName.${getFileExtension(file: file)}');
      var copiedFile = await file.copy(localFile.path);
      log('Image saved to: ${copiedFile.path}');
      return localFile.path;
    } catch (e) {
      log('Error saving image: $e');
    }
  }
}
