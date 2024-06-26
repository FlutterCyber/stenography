import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stenography/service/file_picker.dart';
import '../../controllers/encryption_key_controller.dart';
import '../../encrypt/encrypt.dart';
import '../../encrypt/key_generation.dart';
import '../../steno/encode.dart';
import '../../service/image_picker.dart';
import '../../service/image_saver.dart';
import 'package:encrypt/encrypt.dart' as MyEncrypt;
import 'package:get/get.dart' hide Trans;

class EncodeFileView extends StatefulWidget {
  const EncodeFileView({Key? key}) : super(key: key);

  @override
  State<EncodeFileView> createState() => _EncodeFileViewState();
}

class _EncodeFileViewState extends State<EncodeFileView>
    with TickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  EncryptionKeyController encryptionKeyController =
      Get.put(EncryptionKeyController());
  String? password;

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
  bool passwordIsVisible = true;
  var logger = Logger();

  Future getEncodedImageWithFile({required File file}) async {
    encodedImage =
        await Encode.hideFileInImage(image: selectedImage!, file: file);
  }

  /// converting Encrypted data type to file data type
  File saveEncryptedToFile(MyEncrypt.Encrypted encryptedData, String fileName) {
    final tempFilePath = getTemporaryFilePath(fileName);
    final file = File(tempFilePath);

    // Convert Encrypted to List<int>
    final List<int> encryptedBytes = encryptedData.bytes;

    // Write encrypted bytes to the file
    file.writeAsBytesSync(encryptedBytes);

    print('Encrypted data saved to: $tempFilePath');
    return file;
  }

  String getTemporaryFilePath(String fileName) {
    // Get the temporary directory
    final tempDir = Directory.systemTemp;

    // Generate a unique file name
    final uniqueFileName = '${DateTime.now()}_$fileName';

    // Combine the temporary directory and the unique file name to get the temporary file path
    final tempFilePath = path.join(tempDir.path, uniqueFileName);

    return tempFilePath;
  }

  Future<void> _encodeFile() async {
    if (encryptionKeyController.encryptionEnabled.value) {
      password = passwordController.text.trim();
    } else {
      password = "123456789";
    }

    if (password!.isNotEmpty) {
      ///gettign AES keys
      String aesKey = await keyGenFunc(keyLength: 256, password: password!);
      String aesIV = await keyGenFunc(keyLength: 128, password: password!);

      if (selectedImage != null) {
        if (pickedFile != null) {
          setState(() {
            isEncoding = true;
          });

          /// encrypting file
          EncrpytWithAES encrpytWithAES = EncrpytWithAES.forFile(
              aesKey: aesKey, aesIV: aesIV, file: pickedFile);

          /// getting encrypted data
          MyEncrypt.Encrypted encrypted = await encrpytWithAES.encryptFile();
          File encryptedFile = saveEncryptedToFile(encrypted, "abdusattor");

          await getEncodedImageWithFile(file: encryptedFile);
          setState(() {
            isEncoding = false;
          });

          _save();
        } else {
          Get.snackbar("Please pick a file".tr(), "",
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

    Get.snackbar("Image saved to".tr(), _path!,
        colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }

  void _pickImageFromGallery() async {
    Navigator.pop(context);
    pickedImage = (await PickImage.pickImage(ImageSource.gallery))!;
    setState(() {
      selectedImage = pickedImage;
    });

    print(pickedImage!.path);
  }

  void _pickImageFromCamera() async {
    Navigator.pop(context);

    pickedImage = (await PickImage.pickImage(ImageSource.camera))!;
    setState(() {
      selectedImage = pickedImage;
    });
    print(pickedImage!.path);
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
          Obx(() => encryptionKeyController.encryptionEnabled.value
              ? Container(
                  margin: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
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
                      ).tr(),
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
                              isEncoding
                                  ? const Text(
                                      "Waiting...",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ).tr()
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 20,
                              ),
                              selectedFile == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.file_present_rounded,
                                          color: Colors.white70,
                                          size: 60,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Text(
                                          "Attach \nsecret file",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ).tr()
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
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
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Attached file's name is:",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                  ),
                                                ).tr(),
                                                Text(
                                                  fileName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Colors.teal,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),

          /// bottom part
        ],
      ),
      floatingActionButton: Container(
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        IconlyBold.document,
                        color: Colors.white,
                      ),
                      Flexible(
                        child: const Text(
                          'Attach file',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ).tr(),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.orange,
                    // Background color
                  ),
                  child: const Icon(
                    IconlyBold.lock,
                    color: Colors.white,
                  ),
                ),
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
                ).tr(),
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
                ).tr(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
