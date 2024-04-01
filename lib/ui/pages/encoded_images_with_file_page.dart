import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../service/get_image_paths.dart';

class EncodedImagesWithFilePage extends StatefulWidget {
  static const String id = "encoded_images_with_file_page";

  const EncodedImagesWithFilePage({Key? key}) : super(key: key);

  @override
  State<EncodedImagesWithFilePage> createState() =>
      _EncodedImagesWithFilePageState();
}

class _EncodedImagesWithFilePageState extends State<EncodedImagesWithFilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3F4E4F),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<String>>(
          future: getExternalStorageImagePaths(path: "file_image"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Display a loading indicator while fetching image paths.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No images found in external storage.');
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final imagePath = snapshot.data![index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
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
                              )),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Container(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
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
