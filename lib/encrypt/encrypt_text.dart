import 'package:encrypt/encrypt.dart';
import 'package:logger/logger.dart';

class EncrpytWithAES {
  String? aesKey;
  String? aesIV;
  String? plainText;
  var logger = Logger();

  EncrpytWithAES(
      {required this.aesKey, required this.aesIV, required this.plainText});

  Encrypted encryptMessage() {
    final Key key = Key.fromBase64(aesKey!);
    final IV iv = IV.fromBase64(aesIV!);
    final encrypter = Encrypter(AES(key));
    final Encrypted encryptedMessage = encrypter.encrypt(plainText!, iv: iv);
    logger.i("Message encrypted succesfully: ${encryptedMessage.base64}");
    return encryptedMessage;
  }
}
