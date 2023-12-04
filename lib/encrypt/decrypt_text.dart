import 'package:encrypt/encrypt.dart';
import 'package:logger/logger.dart';

class DecryptWithAES {
  String? aesKey;
  String? aesIV;
  String? cipherText;
  var logger = Logger();

  DecryptWithAES(
      {required this.aesKey, required this.aesIV, required this.cipherText});

  String decryptMessage() {
    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);
    Encrypted encryptedMessage = Encrypted.fromBase64(cipherText!);
    final encrypter = Encrypter(AES(key));
    final decryptedMessage = encrypter.decrypt(encryptedMessage, iv: iv);
    logger.i("Message decrypted seccesfully: $decryptedMessage");
    return decryptedMessage;
  }
}
