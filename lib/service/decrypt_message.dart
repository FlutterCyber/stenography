import '../encrypt/decrypt.dart';

Future<String> decryptMessage(Map<String, dynamic> params) async {
  String aesKey = params["aesKey"];
  String aesIV = params["aesIV"];
  String decodedMessage = params["decodedMessage"];

  DecryptWithAES decryptWithAES = DecryptWithAES.text(
      aesKey: aesKey, aesIV: aesIV, cipherText: decodedMessage);
  String decryptedMessage = decryptWithAES.decryptMessage();
  return decryptedMessage;
}