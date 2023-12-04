import 'dart:io';
import 'package:path/path.dart' as mypath;

fileExtension(File file) {
  return mypath.extension(file.path).toLowerCase();
}
