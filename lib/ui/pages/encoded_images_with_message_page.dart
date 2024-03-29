import 'dart:io';
import 'package:flutter/material.dart';
import '../../service/get_image_paths.dart';

class EncodedImagesWithMessagePage extends StatefulWidget {
  static const String id = "encoded_images_with_message_page";

  const EncodedImagesWithMessagePage({Key? key}) : super(key: key);

  @override
  State<EncodedImagesWithMessagePage> createState() =>
      _EncodedImagesWithMessagePageState();
}

class _EncodedImagesWithMessagePageState
    extends State<EncodedImagesWithMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xff2C3639),
      backgroundColor: const Color(0xff3F4E4F),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<String>>(
          future: getExternalStorageImagePaths(path: "message_image"),
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
                  crossAxisCount: 2, // Adjust the number of columns as needed.
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final imagePath = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
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
