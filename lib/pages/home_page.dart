import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:stenography/pages/all_encoded_images.dart';
import 'package:stenography/views/decode_view.dart';
import 'package:stenography/views/encode_file_view.dart';
import 'package:stenography/views/encode_message_view.dart';
import '../controllers/tab_bar_controller.dart';

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
  Widget build(BuildContext context) {
    TabBarIndexController controller = Get.put(TabBarIndexController());

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xffDCD7C9)),
        backgroundColor: const Color(0xff3F4E4F),
        title: const Text(
          "Home Page",
          style: TextStyle(
            color: Color(0xffDCD7C9),
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
                          )
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
                          )
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
                          )
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
                    ),
                  ),
                ),
              ],
            ),

            /// display image part
            Expanded(
              child: TabBarView(
                children: [
                  _changePage ? const EncodeMessageView() : const EncodeFileView(),
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
