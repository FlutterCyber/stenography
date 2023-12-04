import 'dart:io';

Future<List<String>> getExternalStorageImagePaths({required String path}) async {
  //final directory = await getExternalStorageDirectory();
  final directory =
  Directory('/storage/emulated/0/Download/steno/$path');
  final List<FileSystemEntity> files =
      Directory(directory.path).listSync();

  final imagePaths = <String>[];
  for (var file in files) {
    if (file is File) {
      final extension = file.path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'png' || extension == 'jpeg') {
        imagePaths.add(file.path);
      }
    }
  }

  return imagePaths;
}
