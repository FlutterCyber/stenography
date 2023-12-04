import 'package:get/get.dart';

class TabBarIndexController extends GetxController {
  var index = 0.obs;

  void changeValue(int index) {
    this.index.value = index;
  }
}
