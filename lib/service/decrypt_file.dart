import 'dart:io';
import 'package:encrypt/encrypt.dart' as MyEncrypt;

import '../data/repositories/extensions.dart';
import '../encrypt/decrypt.dart';
import 'create_file_from_bytes.dart';

Future<File> decryptFile(Map<String, dynamic> params) async {
  String aesKey = params["aesKey"];
  String aesIV = params["aesIV"];
  MyEncrypt.Encrypted encr = params["encr"];

  DecryptWithAES decryptWithAESFile =
      DecryptWithAES.file(aesKey: aesKey, aesIV: aesIV, encryptedFile: encr);
  List<int> lst = decryptWithAESFile.decryptFile();

  /// kengaytmani ajratib olish
  int extensionNumber = lst.last;
  String? extension = extensions[extensionNumber];
  if (extensions.containsKey(extensionNumber)) lst.removeLast();
  File decryptedFile =
      await createFileFromBytes(fileBytes: lst, fileExtension: extension!);
  return decryptedFile;
}
