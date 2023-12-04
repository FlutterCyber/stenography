import 'dart:developer';
import 'dart:io';
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
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final localFile = File('${stenoDirectory!.path}/$uniqueFileName.png');
      var copiedFile = await file.copy(localFile.path);
      log('Image saved to: ${copiedFile.path}');
      return localFile.path;
    } catch (e) {
      log('Error saving image: $e');
    }
  }

  Future saveDecodedFileToLocalFolder(File file,String decodedFilename) async {
    try {
      stenoDirectory = await CreateFolder.decodedFileFolder();
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      final localFile = File('${stenoDirectory!.path}/$uniqueFileName.${fileExtension(file)}');
      var copiedFile = await file.copy(localFile.path);
      log('Image saved to: ${copiedFile.path}');
      return localFile.path;
    } catch (e) {
      log('Error saving image: $e');
    }
  }
}
