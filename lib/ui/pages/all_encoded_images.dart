import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:stenography/ui/pages/show_images_page.dart';
import '../colors.dart';
import '../screens/tab_item_widget.dart';
import 'home_page.dart';

class AllEncodedImages extends StatefulWidget {
  static const String id = "all_encoded_images";

  const AllEncodedImages({Key? key}) : super(key: key);

  @override
  State<AllEncodedImages> createState() => _AllEncodedImagesState();
}

class _AllEncodedImagesState extends State<AllEncodedImages> {
  int tabBarIndex = 0;

  // bool platformIs = true bolsa mobil, bool platformIs = false bolsa windows deb oldim
  bool platformIs = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isWindows) {
      setState(() {
        platformIs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: color5,
          ),
        ),
        backgroundColor: color3,
        title: const Text(
          "All encoded images",
          style: TextStyle(color: color5),
        ).tr(),
        centerTitle: true,
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 40,
                    width: platformIs
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.7,
                    // margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xff9BBEC8),
                    ),
                    child: const TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: color1,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      tabs: [
                        TabItem(
                          title: 'Message',
                          icon: IconlyBold.message,
                        ),
                        TabItem(
                          title: 'File',
                          icon: IconlyBold.document,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              children: [
                ShowImagesPage(fileType: "message_image"),
                ShowImagesPage(fileType: "file_image"),

                //EncodedImagesWithMessagePage(),
                //EncodedImagesWithFilePage(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
