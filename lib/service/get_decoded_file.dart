import 'dart:io';

import '../steno/decode.dart';

Future<File?> getDecodedFile(Map<String, dynamic> params) async {
  File image = params['image'];
  return await Decode.decode_image_with_file(image);
}
