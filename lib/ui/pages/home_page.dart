import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:stenography/service/create_folder.dart';
import 'package:stenography/ui/colors.dart';
import 'package:stenography/ui/screens/drawer.dart';
import '../../controllers/encryption_key_controller.dart';
import '../../controllers/tab_bar_controller.dart';
import '../screens/decode_view.dart';
import '../screens/encode_file_view.dart';
import '../screens/encode_message_view.dart';
import 'all_encoded_images.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _changePage = false;
  int tabBarIndex = 0;
  var logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createFolders();
    encryptionDatas();
  }

  void createFolders() {
    CreateFolder.decodedFileFolder().then((value) => {print("MANA 1: $value")});
    CreateFolder.decryptedFileFolder()
        .then((value) => {print("MANA 2: $value")});
    CreateFolder.fileImageFolder().then((value) => {print("MANA 3: $value")});
    CreateFolder.messageImageFolder()
        .then((value) => {print("MANA 4: $value")});
  }

  void encryptionDatas() {
    EncryptionKeyController encryptionKeyController =
        Get.put(EncryptionKeyController());
    logger.i("Kalit: ${encryptionKeyController.encryptionEnabled}");
  }

  @override
  Widget build(BuildContext context) {
    TabBarIndexController controller = Get.put(TabBarIndexController());

    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: color5),
        backgroundColor: color2,
        title: const Text(
          "Hide",
          style: TextStyle(
            color: color5,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffEEF7FF),
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// tab bar
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: TabBar(
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                onTap: (int myIndex) {
                  setState(() {
                    tabBarIndex = myIndex;
                    controller.changeValue(myIndex);
                  });
                },
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 20, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color:
                            controller.index == 0 ? Color(0xff4D869C) : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: controller.index == 0
                                ? Colors.white
                                : color1,
                            child: Icon(
                              IconlyLight.lock,
                              color: controller.index == 0
                                  ? color1
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Encode",
                            style: TextStyle(
                                color: controller.index == 0
                                    ? Colors.white
                                    : color1,
                                fontWeight: FontWeight.w600),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 20, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color:
                            controller.index == 1 ? color1 : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: controller.index == 1
                                ? Colors.white
                                : color1,
                            child: Icon(
                              IconlyLight.unlock,
                              color: controller.index == 1
                                  ? color1
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Decode",
                            style: TextStyle(
                                color: controller.index == 1
                                    ? Colors.white
                                    : color1,
                                fontWeight: FontWeight.w600),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _changePage = !_changePage;
                      });
                    },
                    child: tabBarIndex == 0
                        ? Text(
                            _changePage ? "Encode file" : "Encode message",
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ).tr()
                        : const SizedBox.shrink(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AllEncodedImages.id);
                    },
                    child: const Text(
                      "All encoded images",
                      style: TextStyle(
                          color: Color(0xff4D869C),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ).tr(),
                  ),
                ),
              ],
            ),

            /// display image part
            Expanded(
              child: TabBarView(
                children: [
                  _changePage
                      ? const EncodeMessageView()
                      : const EncodeFileView(),
                  const DecodeView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
