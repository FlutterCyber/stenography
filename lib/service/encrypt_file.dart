import 'dart:io';

import 'package:encrypt/encrypt.dart' as MyEncrypt;

import '../encrypt/encrypt.dart';

Future<MyEncrypt.Encrypted> encryptFile(Map<String, dynamic> params) async {
  String aesKey = params['aesKey'];
  String aesIV = params['aesIV'];
  File pickedFile = params['pickedFile'];

  EncrpytWithAES encrpytWithAES =
      EncrpytWithAES.forFile(aesKey: aesKey, aesIV: aesIV, file: pickedFile);

  MyEncrypt.Encrypted encrypted = await encrpytWithAES.encryptFile();
  return encrypted;
}
