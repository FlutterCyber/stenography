import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as MyEncrypt;
import 'package:logger/logger.dart';
import 'package:stenography/encrypt/decrypt_text.dart';
import 'package:stenography/service/hive_service.dart';

import '../encrypt/encrypt_text.dart';

class EncryptPage extends StatefulWidget {
  static const String id = "encrypt_page";

  const EncryptPage({Key? key}) : super(key: key);

  @override
  State<EncryptPage> createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  TextEditingController textEditingController = TextEditingController();
  MyEncrypt.Encrypted? encryptedMessage;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  void doIt() async {
    String plainText = textEditingController.text.trim();
    String aesKey = HiveService.loadKey();
    String aesIV = HiveService.loadIV();
    EncrpytWithAES encrpytWithAES =
        EncrpytWithAES(aesKey: aesKey, aesIV: aesIV, plainText: plainText);
    encryptedMessage = encrpytWithAES.encryptMessage();

    log("Encrypted message is: ${encryptedMessage!.base64}");
  }

  // void decryptMessage() {
  //   String aesKey = HiveService.loadKey();
  //   String aesIV = HiveService.loadIV();
  //   DecryptWithAES decryptWithAES = DecryptWithAES(
  //       aesKey: aesKey, aesIV: aesIV, cipherText: encryptedMessage);
  //   log("Decrypted message is: ${decryptWithAES.decryptMessage()}");
  // }

  void saveKeyAndIV(String aesKey, String aesIV) async {
    try {
      await HiveService.storeKey(aesKey);
      await HiveService.storeIV(aesIV);
    } catch (e) {
      print("Aes key and IV storing error: $e");
    }
  }

  void getKey() {
    String aesKey = HiveService.loadKey();
    log("Loaded aeskey is: $aesKey");
  }

  void getIV() {
    String aesIV = HiveService.loadIV();
    log("Loaded aesIV is: $aesIV");
  }

  void sinash() {
    String plainText = textEditingController.text.trim();
    String aesKey = HiveService.loadKey();
    String aesIV = HiveService.loadIV();
    EncrpytWithAES encrpytWithAES =
        EncrpytWithAES(aesKey: aesKey, aesIV: aesIV, plainText: plainText);
    MyEncrypt.Encrypted encryptedMessage = encrpytWithAES.encryptMessage();

    logger.i("Encrypted message bytes: ${encryptedMessage.base64}");
    MyEncrypt.Encrypted encryptedMessage2 =
        MyEncrypt.Encrypted.fromBase64(encryptedMessage.base64);
    logger.w("Decrypted message bytes: ${encryptedMessage2.base64}");


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingController,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Type your secret message',
                hintStyle: TextStyle(color: Colors.grey),
                //border: InputBorder.none,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                doIt();
              },
              child: const Text(
                "Encrypt",
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
               // decryptMessage();
              },
              child: const Text(
                "Decrypt",
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                sinash();
              },
              child: const Text(
                "Sinash",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
