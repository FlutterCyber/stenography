import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stenography/service/file_picker.dart';

import '../steno/encode.dart';
import '../service/image_picker.dart';
import '../service/image_saver.dart';

class EncodeFileView extends StatefulWidget {
  const EncodeFileView({Key? key}) : super(key: key);

  @override
  State<EncodeFileView> createState() => _EncodeFileViewState();
}

class _EncodeFileViewState extends State<EncodeFileView>
    with TickerProviderStateMixin {
  List<File> imageFiles = [];
  File? selectedImage;
  File? pickedImage;
  File? pickedFile;
  File? selectedFile;
  File? encodedImage;
  String? _path;
  String? fileName;
  bool isEncoding = false;
  bool isSaving = false;
  late AnimationController _controller;

  Future getEncodedImageWithFile({required File file}) async {
    encodedImage =
        await Encode.hideFileInImage(image: selectedImage!, file: file);
  }

  Future<void> _encodeFile() async {
    if (selectedImage != null) {
      if (pickedFile != null) {
        setState(() {
          isEncoding = true;
        });
        await getEncodedImageWithFile(file: pickedFile!);
        setState(() {
          isEncoding = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(encodedImage!.path)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a file')),
        );
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
  }

  void _attachFile() async {
    pickedFile = await PickFile.pickFile();
    setState(() {
      selectedFile = pickedFile;
      fileName = path.basename(selectedFile!.path).toString();
    });
  }

  void _save() async {
    setState(() {
      isEncoding = true;
    });
    _path = await ImageSaver().saveImageToLocalFolder(encodedImage!, 2);
    setState(() {
      isEncoding = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved to: $_path'),
      ),
    );
  }

  void _pickImageFromGallery() async {
    Navigator.pop(context);
    pickedImage = (await PickImage.pickImage(ImageSource.gallery))!;
    setState(() {
      selectedImage = pickedImage;
    });

    print(pickedImage!.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pickedImage!.path}')),
    );
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);

    pickedImage = (await PickImage.pickImage(ImageSource.camera))!;
    setState(() {
      selectedImage = pickedImage;
    });
    print(pickedImage!.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pickedImage!.path}')),
    );
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C3639),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectedImage == null
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: LottieBuilder.asset(
                          "assets/lotties/1.json",
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
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              isEncoding
                                  ? const Text(
                                      "Waiting...",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                margin: EdgeInsets.all(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13.0),
                                  // Set your desired border radius here

                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              selectedFile == null
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.file_present_rounded,
                                          color: Colors.white70,
                                          size: 60,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Attach \nsecret file",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.file_open_rounded,
                                          color: Colors.white70,
                                          size: 60,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Attached file's name is:",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Text(
                                              fileName!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          /// bottom part
          Container(
            width: double.infinity,
            height: 60,
            color: const Color(0xff3F4E4F),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _displayBottomSheet();
                  },
                  icon: const Icon(
                    Icons.attach_file_outlined,
                    color: Color(0xffDCD7C9),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        _attachFile();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.blue,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            IconlyBold.document,
                            color: Colors.white,
                          ),
                          Text(
                            'Attach file',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _encodeFile();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.orange,
                        // Background color
                      ),
                      child: const Icon(
                        IconlyBold.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _save();
                  },
                  icon: const Icon(
                    Icons.save_alt,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// bottom sheet
  Future _displayBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff3F4E4F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(15),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    _pickImageFromGallery();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: Icon(
                      IconlyBold.document,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "File",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImageFromCamera();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 30,
                    child: Icon(
                      IconlyBold.camera,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Camera",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
