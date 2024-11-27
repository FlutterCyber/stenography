import 'dart:io';
import '../steno/encode.dart';

Future<File> getEncodedImageWithFile(Map<String, dynamic> params) async {
  File image = params['image'];
  File file = params['file'];
  return await Encode.hideFileInImage(image: image, file: file);
}
