import 'dart:io';

import '../steno/decode.dart';

Future<String?> getDecodedMessage(Map<String, dynamic> params) async {
  File image = params['image'];
  return await Decode.decode_image_with_message(image);
}
