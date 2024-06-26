import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:stenography/ui/pages/home_page.dart';
import 'package:path/path.dart' as path;
import '../../service/get_image_paths.dart';

class AllDecodedFilesPage extends StatefulWidget {
  static const String id = "all_decoded_files_page";

  const AllDecodedFilesPage({super.key});

  @override
  State<AllDecodedFilesPage> createState() => _AllDecodedFilesPageState();
}

class _AllDecodedFilesPageState extends State<AllDecodedFilesPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  String? fileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    try {
      if (await file.exists()) {
        await file.delete();
        setState(() {});
        Get.snackbar("File deleted successfully".tr(), "",
            colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Failed to delete the file: $e", "",
          colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      await OpenFilex.open(filePath);
    } catch (e) {
      Get.snackbar("Failed to open the file: $e", "",
          colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C3639),
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
        iconTheme: const IconThemeData(color: Color(0xffDCD7C9)),
        backgroundColor: const Color(0xff3F4E4F),
        title: const Text(
          "Decoded informations",
          style: TextStyle(
            color: Color(0xffDCD7C9),
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<String>>(
          future: getExternalStorageImagePaths(path: "decoded_files"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Display a loading indicator while fetching image paths.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: LottieBuilder.asset(
                        "assets/lotties/no_file.json",
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller.duration = composition.duration;
                          _controller.forward();
                        },
                      ),
                    ),
                    const Text(
                      "File is empty",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  final imagePath = snapshot.data![index];
                  fileName = path.basename(imagePath).toString();
                  return GestureDetector(
                    onTap: () {
                      openFile(imagePath);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 10,
                      ),
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            fileName!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteFile(imagePath);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
