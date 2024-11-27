import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stenography/ui/colors.dart';
import '../../service/get_image_paths.dart';

class ShowImagesPage extends StatefulWidget {
  String? fileType;
  static const String id = "show_images_page";

  ShowImagesPage({Key? key, required this.fileType}) : super(key: key);

  @override
  State<ShowImagesPage> createState() => _ShowImagesPageState();
}

class _ShowImagesPageState extends State<ShowImagesPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // bool platformIs = true bolsa mobil, bool platformIs = false bolsa windows deb oldim
  bool platformIs = true;
  bool waitForMe = true;

  // Function to share image
  void _shareImage(String imagePath) async {
    await Share.shareXFiles(
      [XFile(imagePath, mimeType: 'application/octet-stream')],
      text: 'Great picture',
    );
  }

  // Function to delete image
  void _deleteImage(String imagePath) {
    File(imagePath).deleteSync(); // Delete the image file synchronously
    setState(() {}); // Refresh the UI
  }

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
    if (Platform.isWindows) {
      setState(() {
        platformIs = false;
      });
    }
    waitMe();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void waitMe() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        waitForMe = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: waitForMe
            ? SizedBox(
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
                        color: color5,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ],
                ),
              )
            : FutureBuilder<List<String>>(
                future: getExternalStorageImagePaths(
                    path: widget.fileType.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ); // Display a loading indicator while fetching image paths.
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
                              color: color5,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                        ],
                      ),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: platformIs ? 2 : 10,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final imagePath = snapshot.data![index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(imagePath),
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () => _shareImage(imagePath),
                                        icon: const Icon(
                                          Icons.share,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () =>
                                            _deleteImage(imagePath),
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
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
