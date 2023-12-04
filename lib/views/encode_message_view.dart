import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../encrypt/encrypt_text.dart';
import '../service/hive_service.dart';
import '../steno/encode.dart';
import '../service/image_picker.dart';
import '../service/image_saver.dart';

class EncodeMessageView extends StatefulWidget {
  const EncodeMessageView({Key? key}) : super(key: key);

  @override
  State<EncodeMessageView> createState() => _EncodeMessageViewState();
}

class _EncodeMessageViewState extends State<EncodeMessageView>
    with TickerProviderStateMixin {
  List<File> imageFiles = [];
  File? selectedImage;
  File? pickedImage;
  File? pickedFile;
  File? encodedImage;
  String? path;
  bool isEncoding = false;
  bool isSaving = false;
  late AnimationController _controller;
  TextEditingController textEditingController = TextEditingController();

  Future getEncodedImage({required String secretMessage}) async {
    encodedImage = await Encode.hideMessageInImage(
      image: selectedImage!,
      secretMessage: secretMessage,
    );
  }

  Future<void> _encode() async {
    String plainText = textEditingController.text.trim();
    ///gettign AES keys
    String aesKey = HiveService.loadKey();
    String aesIV = HiveService.loadIV();
    /// encrypting message
    EncrpytWithAES encrpytWithAES =
        EncrpytWithAES(aesKey: aesKey, aesIV: aesIV, plainText: plainText);
    String secretMessage = encrpytWithAES.encryptMessage().base64;

    if (selectedImage != null) {
      if (plainText.isNotEmpty) {
        setState(() {
          isEncoding = true;
        });
        await getEncodedImage(secretMessage: secretMessage);
        setState(() {
          isEncoding = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${encodedImage!.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a secret message')),
        );
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }
  }

  void _pickImageFromGallery() async {
    Navigator.pop(context);

    pickedImage = (await PickImage.pickImage(ImageSource.gallery))!;
    setState(() {
      selectedImage = pickedImage;
    });

    log(pickedImage!.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pickedImage!.path)),
    );
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);

    pickedImage = (await PickImage.pickImage(ImageSource.camera))!;
    setState(() {
      selectedImage = pickedImage;
    });
    log(pickedImage!.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pickedImage!.path)),
    );
  }

  void _save() async {
    //Directory? stenoDirectory = await CreateFolder.stenoFolder();
    setState(() {
      isEncoding = true;
    });
    path = await ImageSaver().saveImageToLocalFolder(encodedImage!, 1);

    setState(() {
      isEncoding = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved to: $path'),
      ),
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
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                margin: const EdgeInsets.all(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13.0),
                                  // Set your desired border radius here

                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              isEncoding
                                  ? const Text(
                                      "Waiting...",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
            height: 50,
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
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(
                      color: Color(0xffDCD7C9),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type your secret message',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _encode();
                  },
                  icon: const Icon(
                    IconlyBold.lock,
                    color: Colors.blue,
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
        padding: const EdgeInsets.all(15),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
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
                  onTap: () async {
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
