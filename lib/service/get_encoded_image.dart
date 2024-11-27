import 'dart:io';
import '../steno/encode.dart';

Future<File> getEncodedImage(Map<String, dynamic> params) async {
  File image = params['image'];
  String secretMessage = params['secretMessage'];
  return await Encode.hideMessageInImage(
    image: image,
    secretMessage: secretMessage,
  );
}
