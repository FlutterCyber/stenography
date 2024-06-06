import 'package:get/get.dart';

class DataTypeController extends GetxController {
  /// fileOrText qiymati false bolsa text, true bolsa file deb olindi
  var fileOrText = false.obs;

  void changeToTrue() {
    fileOrText.value = true;
  }
  void changeToFalse() {
    fileOrText.value = false;
  }
}
