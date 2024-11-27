import '../../encrypt/encrypt.dart';

Future<String> encryptyMessage(Map<String, dynamic> params) async {
  String aesKey = params["aesKey"];
  String aesIV = params["aesIV"];
  String plainText = params["plainText"];

  EncrpytWithAES encrpytWithAES = EncrpytWithAES.forText(
      aesKey: aesKey, aesIV: aesIV, plainText: plainText);
  String secretMessage = encrpytWithAES.encryptText().base64;
  return secretMessage;
}
