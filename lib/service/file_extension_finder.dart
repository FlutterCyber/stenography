import 'dart:io';
import 'package:path/path.dart' as mypath;

String getFileExtension({required File file}) {
  String extension = mypath.extension(file.path).toLowerCase();
  return extension;
}
