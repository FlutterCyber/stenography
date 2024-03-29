import 'package:get/get.dart';

class MyDrawerController extends GetxController {
  var mode = true.obs;
  var isExpanded1 = false.obs;
  var isExpanded2 = false.obs;
  var passwordVisibility = false.obs;
  var isChecked = false.obs;
  List<String> encryptionOptions = [
    "No Encryption",
    "AES 128",
    "AES 256",
    "AES 512"
  ];
  List<String> languageOptions = [
    "Uzbek",
    "Russian",
    "English",
  ];

  var currentEncryptionOption = "".obs;
  var currentLanguageOption = "".obs;

  MyDrawerController() {
    currentEncryptionOption.value = encryptionOptions[2];
    currentLanguageOption.value = languageOptions[1];
  }

  void changeEncryptionOption(value) {
    currentEncryptionOption.value = value.toString();
  }

  void changeLanguageOption(value) {
    currentLanguageOption.value = value.toString();
  }

  void changeMode() {
    mode.value = !mode.value;
  }

  void changeExpand1() {
    isExpanded1.value = !isExpanded1.value;
  }

  void changeExpand2() {
    isExpanded2.value = !isExpanded2.value;
  }

  void changePasswordVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }
}
