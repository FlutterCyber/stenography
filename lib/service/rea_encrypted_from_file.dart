import 'dart:io';

import 'package:encrypt/encrypt.dart' as MyEncrypt;

MyEncrypt.Encrypted readEncryptedFromFile(String filePath) {
  final file = File(filePath);
  // Read encrypted bytes from the file
  final encryptedBytes = file.readAsBytesSync();
  // Create an Encrypted object using the bytes
  final encryptedData = MyEncrypt.Encrypted(encryptedBytes);
  return encryptedData;
}
