import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:stenography/service/create_folder.dart';
import 'package:stenography/ui/screens/drawer.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createFolders();
  }

  void createFolders() {
    CreateFolder.decodedFileFolder().then((value) => {print("MANA 1: $value")});
    CreateFolder.decryptedFileFolder()
        .then((value) => {print("MANA 2: $value")});
    CreateFolder.fileImageFolder().then((value) => {print("MANA 3: $value")});
    CreateFolder.messageImageFolder()
        .then((value) => {print("MANA 4: $value")});
  }

  @override
  Widget build(BuildContext context) {
    TabBarIndexController controller = Get.put(TabBarIndexController());

    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xffDCD7C9)),
        backgroundColor: const Color(0xff3F4E4F),
        title: const Text(
          "Shield",
          style: TextStyle(
            color: Color(0xffDCD7C9),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xff2C3639),
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
                            controller.index == 0 ? Colors.blue : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: controller.index == 0
                                ? Colors.white
                                : Colors.blue,
                            child: Icon(
                              IconlyLight.lock,
                              color: controller.index == 0
                                  ? Colors.blue
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
                                    : Colors.blue,
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
                            controller.index == 1 ? Colors.blue : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: controller.index == 1
                                ? Colors.white
                                : Colors.blue,
                            child: Icon(
                              IconlyLight.unlock,
                              color: controller.index == 1
                                  ? Colors.blue
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
                                    : Colors.blue,
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
                          color: Colors.blue,
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
