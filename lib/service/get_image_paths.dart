import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<List<String>> getExternalStorageImagePaths(
    {required String path}) async {
  Directory? directory;
  if (Platform.isAndroid) {
    directory = Directory('/storage/emulated/0/Download/steno/$path');
  } else if (Platform.isIOS) {
    final myFilesDirectory = await getApplicationDocumentsDirectory();
    directory = Directory('${myFilesDirectory!.path}/$path');
  }

  final List<FileSystemEntity> files = Directory(directory!.path).listSync();

  final imagePaths = <String>[];
  for (var file in files) {
    if (file is File) {
      final extension = file.path.split('.').last.toLowerCase();
      if (extension == 'jpg' ||
          extension == 'png' ||
          extension == 'jpeg' ||
          extension == 'pdf' ||
          extension == 'doc' ||
          extension == 'docx' ||
          extension == 'mp3' ||
          extension == 'mp4' ||
          extension == 'doc' ||
          extension == 'tiff' ||
          extension == 'bmp' ||
          extension == 'mpeg' ||
          extension == 'mkv' ||
          extension == 'wmv' ||
          extension == 'webm' ||
          extension == 'vob') {
        imagePaths.add(file.path);
      }
    }
  }

  return imagePaths;
}
