import 'package:get/get.dart';

class EncryptionKeyController extends GetxController {
  var encryptionEnabled = true.obs;

  void changeToFalse() {
    encryptionEnabled.value = false;
  }

  void changeTotrue() {
    encryptionEnabled.value = true;
  }
}
