import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<List<String>> getExternalStorageImagePaths(
    {required String path}) async {
  Directory? myFilesDirectory;

  if (Platform.isWindows) {
    myFilesDirectory = Directory("C:/Users/user1/Desktop/Steno");
  } else {
    myFilesDirectory = await getApplicationDocumentsDirectory();
  }

  return await compute(_getImagePaths, '${myFilesDirectory.path}/$path');
}

List<String> _getImagePaths(String directoryPath) {
  final List<FileSystemEntity> files = Directory(directoryPath).listSync();
  final imagePaths = <String>[];
  for (var file in files) {
    if (file is File) {
      final extension = file.path.split('.').last.toLowerCase();
      if ([
        'jpg',
        'png',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'mp3',
        'mp4',
        'tiff',
        'bmp',
        'mpeg',
        'mkv',
        'wmv',
        'webm',
        'vob'
      ].contains(extension)) {
        imagePaths.add(file.path);
      }
    }
  }
  return imagePaths;
}
