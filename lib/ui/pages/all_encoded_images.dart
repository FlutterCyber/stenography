import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:stenography/ui/pages/show_images_page.dart';
import 'home_page.dart';

class AllEncodedImages extends StatefulWidget {
  static const String id = "all_encoded_images";

  const AllEncodedImages({Key? key}) : super(key: key);

  @override
  State<AllEncodedImages> createState() => _AllEncodedImagesState();
}

class _AllEncodedImagesState extends State<AllEncodedImages> {
  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff3F4E4F),
        title: const Text(
          "All encoded images",
          style: TextStyle(color: Colors.white),
        ).tr(),
        centerTitle: true,
      ),
      body: Scaffold(
        backgroundColor: const Color(0xff3F4E4F),
        body: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 1, left: 1),
                margin: const EdgeInsets.only(right: 15, left: 15),
                decoration: BoxDecoration(
                  color: const Color(0xff2C3639),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: TabBar(
                  padding: const EdgeInsets.all(0),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  onTap: (int index) {
                    setState(() {
                      tabBarIndex = index;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: tabBarIndex == 0
                                ? Colors.white10
                                : const Color(0xff2C3639),
                            width: 1.0,
                          ),
                          color: tabBarIndex == 0
                              ? const Color(0xff3F4E4F)
                              : const Color(0xff2C3639),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyBold.message,
                              color:
                                  tabBarIndex == 0 ? Colors.blue : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                "Message",
                                overflow: TextOverflow.ellipsis,

                                style: TextStyle(
                                    color: tabBarIndex == 0
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ).tr(),
                            ),
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
                          border: Border.all(
                            color: tabBarIndex == 1
                                ? Colors.white10
                                : const Color(0xff2C3639),
                            width: 1.0,
                          ),
                          color: tabBarIndex == 1
                              ? const Color(0xff3F4E4F)
                              : const Color(0xff2C3639),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyBold.document,
                              color:
                                  tabBarIndex == 1 ? Colors.blue : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "File",
                              style: TextStyle(
                                color: tabBarIndex == 1
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ).tr()
                          ],
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
