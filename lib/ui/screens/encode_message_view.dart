import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/encryption_key_controller.dart';
import '../../encrypt/encrypt.dart';
import '../../encrypt/key_generation.dart';
import '../../service/encrypt_message.dart';
import '../../service/get_encoded_image.dart';
import '../../steno/encode.dart';
import '../../service/image_picker.dart';
import '../../service/image_saver.dart';
import '../colors.dart';

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
  bool passwordIsVisible = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  EncryptionKeyController encryptionKeyController =
      Get.put(EncryptionKeyController());
  String? password;


  void _shareImage(String imagePath) async {
    await Share.shareXFiles(
      [XFile(imagePath, mimeType: 'application/octet-stream')],
      text: 'Great picture',
    );
  }

  Future<void> _encode() async {
    String plainText = textEditingController.text.trim();
    if (encryptionKeyController.encryptionEnabled.value) {
      password = passwordController.text.trim();
    } else {
      password = "123456789";
    }

    if (password!.isNotEmpty) {
      if (selectedImage != null) {
        if (plainText.isNotEmpty) {
          setState(() {
            isEncoding = true;
          });

          ///gettign AES keys
          String aesKey = await keyGenFunc(keyLength: 256, password: password!);
          String aesIV = await keyGenFunc(keyLength: 128, password: password!);

          /// encrypting message
          String secretMessage = await compute(encryptyMessage,
              {"aesKey": aesKey, "aesIV": aesIV, "plainText": plainText});

          encodedImage = await compute(getEncodedImage, {
            'image': selectedImage!,
            'secretMessage': secretMessage,
          });
          setState(() {
            isEncoding = false;
          });

          await _save();
        } else {
          Get.snackbar("Please enter a secret message".tr(), "",
              colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          return;
        }
      } else {
        Get.snackbar("Please select an image".tr(), "",
            colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        return;
      }
    } else {
      Get.snackbar("Please enter a password".tr(), "",
          colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
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
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);

    pickedImage = (await PickImage.pickImage(ImageSource.camera))!;
    setState(() {
      selectedImage = pickedImage;
    });
    log(pickedImage!.path);
  }

  Future<void> _save() async {
    setState(() {
      isEncoding = true;
    });
    path = await ImageSaver().saveImageToLocalFolder(encodedImage!, 1);

    setState(() {
      isEncoding = false;
    });

    Get.snackbar("Image saved to".tr(), path!,
        colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
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
      backgroundColor: color3,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => encryptionKeyController.encryptionEnabled.value
              ? Container(
                  margin: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  height: 55,
                  decoration: BoxDecoration(
                    color: color4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      controller: passwordController,
                      obscureText: passwordIsVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          IconlyBold.lock,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordIsVisible = !passwordIsVisible;
                            });
                          },
                          icon: passwordIsVisible
                              ? const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                        ),
                        border: InputBorder.none,
                        hintText: "Enter password",
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()),
          selectedImage == null
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: LottieBuilder.asset(
                          "assets/lotties/1234.json",
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
              : Expanded(
                  child: ListView(
                    children: [
                      isEncoding
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const CircularProgressIndicator()),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(selectedImage!.path),
                            ),
                          ),
                        ),
                        margin: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.0),
                          // Set your desired border radius here
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
                                child: encodedImage != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () => _shareImage(
                                                  encodedImage!.path),
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
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          /// bottom part
        ],
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 50,
        color: color4,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _displayBottomSheet();
              },
              icon: const Icon(
                Icons.attach_file_outlined,
                color: color5,
              ),
            ),
            Expanded(
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: color5,
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
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                ).tr(),
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
                ).tr(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
