import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import 'create_folder.dart';

Future<File> createFileFromBytes(
    {required List<int> fileBytes, required String fileExtension}) async {
  final folder = await CreateFolder.decryptedFileFolder();
  // final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
  final String uniqueFileName = formatter.format(now);

  final file = File('${folder!.path}/$uniqueFileName.$fileExtension');
  file.writeAsBytesSync(fileBytes);
  return file;
}
