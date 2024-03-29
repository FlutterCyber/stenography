import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:logger/logger.dart';
import 'package:stenography/data/repositories/extensions.dart';
import '../service/file_extension_finder.dart';

class EncrpytWithAES {
  String? aesKey;
  String? aesIV;
  String? plainText;
  File? file;
  var logger = Logger();

  EncrpytWithAES.forText(
      {required this.aesKey, required this.aesIV, required this.plainText});

  EncrpytWithAES.forFile(
      {required this.aesKey, required this.aesIV, required this.file});

  /// this function encrypts texts
  Encrypted encryptText() {
    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);

    final encrypter = Encrypter(AES(key));
    final Encrypted encryptedMessage = encrypter.encrypt(plainText!, iv: iv);
    logger.i(encrypter.encryptBytes([1, 2, 3], iv: iv).base64);
    logger.i("Message encrypted succesfully: ${encryptedMessage.base64}");
    return encryptedMessage;
  }

  /// this function encrypts files
  Future<Encrypted> encryptFile() async {
    /// file kengaytmasi (extension) haqidagi ma'lumotni fayl
    /// baytlari listiga qo'shib, songra shu list shifrlanyapti.
    /// Shu extension haqidagi ma'lumot - listning eng oxirgi elementi

    List<int> fileContent = <int>[];
    fileContent.addAll(file!.readAsBytesSync());

    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);
    logger.w(key.length);
    logger.w(iv.bytes.length);
    final encrypter = Encrypter(AES(key));

    String extension = getFileExtension(file: file!);

    extensions.forEach((extensionNumber, extensionName) {
      if (extension == extensionName) {
        logger.e("Extension key is: $extensionNumber, value is $extensionName");
        try {
          fileContent.add(extensionNumber!);
          logger.d("Extension number added to list successfully");
        } catch (e) {
          logger.e("Adding to list error: $e");
        }
      }
    });

    final Encrypted encryptedFile = encrypter.encryptBytes(fileContent, iv: iv);
    logger.i("File encrypted succesfully: ${encryptedFile.base64}");
    return encryptedFile;
  }
}
