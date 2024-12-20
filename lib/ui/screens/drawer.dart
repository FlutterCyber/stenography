import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:stenography/controllers/encryption_key_controller.dart';
import 'package:stenography/ui/pages/all_decoded_files_page.dart';
import '../../controllers/drawer_controller.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    MyDrawerController drawerController = Get.put(MyDrawerController());
    EncryptionKeyController encryptionKeyController =
        Get.put(EncryptionKeyController());
    return Drawer(
      child: Container(
        color: const Color(0xff2C3639), // Dark background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff3F4E4F),
                //const Color(0xff3F4E4F),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/mylogo.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return ExpansionTile(
                  trailing: Icon(
                    drawerController.isExpanded1.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onExpansionChanged: (bool expanded) {
                    drawerController.changeExpand1();
                  },
                  initiallyExpanded: drawerController.isExpanded1.value,
                  title: Row(
                    children: [
                      const Icon(
                        IconlyBold.lock,
                        size: 27,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: const Text(
                          "Encryption key",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                  children: [
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "No encryption",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ).tr(),
                        activeColor: Colors.blue,
                        value: drawerController.encryptionOptions[0].toString(),
                        groupValue:
                            drawerController.currentEncryptionOption.toString(),
                        onChanged: (value) {
                          drawerController.changeEncryptionOption(value);
                          logger
                              .e("${drawerController.currentEncryptionOption}");
                          encryptionKeyController.changeToFalse();
                          logger.e(encryptionKeyController.encryptionEnabled);
                        },
                      ),
                    ),
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "AES 128",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        activeColor: Colors.blue,
                        value: drawerController.encryptionOptions[1].toString(),
                        groupValue:
                            drawerController.currentEncryptionOption.toString(),
                        onChanged: (value) {
                          drawerController.changeEncryptionOption(value);
                          logger
                              .e("${drawerController.currentEncryptionOption}");
                          encryptionKeyController.changeTotrue();
                          logger.e(encryptionKeyController.encryptionEnabled);
                        },
                      ),
                    ),
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "AES 192",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        activeColor: Colors.blue,
                        value: drawerController.encryptionOptions[3].toString(),
                        groupValue:
                            drawerController.currentEncryptionOption.toString(),
                        onChanged: (value) {
                          drawerController.changeEncryptionOption(value);
                          logger
                              .e("${drawerController.currentEncryptionOption}");
                          encryptionKeyController.changeTotrue();
                          logger.e(encryptionKeyController.encryptionEnabled);
                        },
                      ),
                    ),
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "AES 256",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        activeColor: Colors.blue,
                        value: drawerController.encryptionOptions[2].toString(),
                        groupValue:
                            drawerController.currentEncryptionOption.toString(),
                        onChanged: (value) {
                          drawerController.changeEncryptionOption(value);
                          logger
                              .e("${drawerController.currentEncryptionOption}");
                          encryptionKeyController.changeTotrue();
                          logger.e(encryptionKeyController.encryptionEnabled);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return ExpansionTile(
                  trailing: Icon(
                    drawerController.isExpanded2.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onExpansionChanged: (bool expanded) {
                    drawerController.changeExpand2();
                  },
                  initiallyExpanded: drawerController.isExpanded2.value,
                  title: Row(
                    children: [
                      const Icon(
                        Icons.language,
                        size: 27,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        "Language",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).tr(),
                    ],
                  ),
                  children: [
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "Uzbek",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ).tr(),
                        activeColor: Colors.blue,
                        value: drawerController.languageOptions[0].toString(),
                        groupValue:
                            drawerController.currentLanguageOption.toString(),
                        onChanged: (value) {
                          drawerController.changeLanguageOption(value);
                          context.setLocale(const Locale('uz', 'UZ'));
                          Get.updateLocale(const Locale('uz', 'UZ'));
                        },
                      ),
                    ),
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "Russian",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ).tr(),
                        activeColor: Colors.blue,
                        value: drawerController.languageOptions[1].toString(),
                        groupValue:
                            drawerController.currentLanguageOption.toString(),
                        onChanged: (value) {
                          drawerController.changeLanguageOption(value);
                          context.setLocale(const Locale('ru', 'RU'));
                          Get.updateLocale(const Locale('ru', 'RU'));
                        },
                      ),
                    ),
                    Obx(
                      () => RadioListTile(
                        title: const Text(
                          "English",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ).tr(),
                        activeColor: Colors.blue,
                        value: drawerController.languageOptions[2].toString(),
                        groupValue:
                            drawerController.currentLanguageOption.toString(),
                        onChanged: (value) {
                          context.setLocale(const Locale('en', 'US'));
                          Get.updateLocale(const Locale('en', 'US'));
                          drawerController.changeLanguageOption(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.orange.withOpacity(0.3),
                // Customize the splash color
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AllDecodedFilesPage.id);
                  },
                  title: Row(
                    children: [
                      const Icon(
                        IconlyBold.password,
                        size: 27,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: const Text(
                          "Decoded files",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
