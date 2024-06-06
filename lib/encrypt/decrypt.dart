import 'package:encrypt/encrypt.dart';
import 'package:logger/logger.dart';

class DecryptWithAES {
  String? aesKey;
  String? aesIV;
  String? cipherText;
  Encrypted? encryptedFile;
  var logger = Logger();

  DecryptWithAES.text(
      {required this.aesKey, required this.aesIV, required this.cipherText});

  DecryptWithAES.file(
      {required this.aesKey, required this.aesIV, required this.encryptedFile});

  String decryptMessage() {
    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);
    Encrypted encryptedMessage = Encrypted.fromBase64(cipherText!);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decryptedMessage = encrypter.decrypt(encryptedMessage, iv: iv);
    logger.i("Message decrypted seccesfully: $decryptedMessage");
    return decryptedMessage;
  }

  List<int> decryptFile() {
    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);
    final encrypter = Encrypter(
      AES(key, mode: AESMode.cbc),
    );

    final List<int> decryptedFile =
        encrypter.decryptBytes(encryptedFile!, iv: iv);
    logger.e("File extension: ${decryptedFile.last}");

    return decryptedFile;
  }
}
