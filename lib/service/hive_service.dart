import 'package:hive/hive.dart';

class HiveService {
  static var box = Hive.box('aesKey');
  static var languageBox = Hive.box("languageBox");

  static storeLanguage(String selectedlanguage) async {
    try {
      await languageBox.put("languageBox", selectedlanguage);
    } catch (e) {
      print("Storing err is $e");
    }
  }

  static String loadLanguage() {
    var selectedlanguage = "";
    try {
      selectedlanguage = languageBox.get("languageBox");
    } catch (e) {
      print(e);
    }
    return selectedlanguage;
  }

  static storeKey(String aesKey) async {
    try {
      await box.put("aesKey", aesKey);
      print("Key saved successfully");
    } catch (e) {
      print("Storing err is $e");
    }
  }

  static storeIV(String aesIV) async {
    try {
      await box.put("aesIV", aesIV);
      print("aesIV saved successfully");
    } catch (e) {
      print("aesIV Storing err is $e");
    }
  }

  static String loadIV() {
    var aesKey = box.get("aesIV");
    return aesKey;
  }

  static String loadKey() {
    var aesKey = box.get("aesKey");
    return aesKey;
  }

  static void deleteKey() {
    box.delete('aesKey');
  }

  static void deleteIV() {
    box.delete('aesIV');
  }
}
