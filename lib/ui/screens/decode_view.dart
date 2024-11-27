import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as MyEncrypt;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as mypath;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stenography/controllers/data_type_controller.dart';
import 'package:stenography/data/repositories/extensions.dart';
import 'package:stenography/service/create_folder.dart';
import 'package:stenography/ui/colors.dart';
import '../../controllers/encryption_key_controller.dart';
import '../../encrypt/decrypt.dart';
import '../../encrypt/key_generation.dart';
import '../../service/decrypt_message.dart';
import '../../service/get_decoded_file.dart';
import '../../service/get_decoded_message.dart';
import '../../service/image_saver.dart';
import '../../service/image_picker.dart';

class DecodeView extends StatefulWidget {
  const DecodeView({Key? key}) : super(key: key);

  @override
  State<DecodeView> createState() => _DecodeViewState();
}

class _DecodeViewState extends State<DecodeView> with TickerProviderStateMixin {
  File? selectedImage;
  File? pickedImage;
  bool isDecoding = false;
  bool isSaving = false;
  String? decodedMessage = "";
  File? decodedFile;
  String? decodedFileName;
  String? _path;
  var logger = Logger();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordIsVisible = true;
  late AnimationController _controller;
  DataTypeController dataTypeController = Get.put(DataTypeController());
  EncryptionKeyController encryptionKeyController =
      Get.put(EncryptionKeyController());
  String? password;

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

  void _pickImage() async {
    pickedImage = (await PickImage.pickImage(ImageSource.gallery))!;
    setState(() {
      selectedImage = pickedImage;
    });

    log(pickedImage!.path);
  }

  MyEncrypt.Encrypted readEncryptedFromFile(String filePath) {
    final file = File(filePath);
    // Read encrypted bytes from the file
    final encryptedBytes = file.readAsBytesSync();
    // Create an Encrypted object using the bytes
    final encryptedData = MyEncrypt.Encrypted(encryptedBytes);
    return encryptedData;
  }

  Future<File> createFileFromBytes(
      {required List<int> fileBytes, required String fileExtension}) async {
    final folder = await CreateFolder.decryptedFileFolder();
    // final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
    final String uniqueFileName = formatter.format(now);

    final file = File('${folder!.path}/$uniqueFileName.$fileExtension');
    file.writeAsBytesSync(fileBytes);
    return file;
  }

  void _decode() async {
    dataTypeController.changeToFalse();
    if (encryptionKeyController.encryptionEnabled.value) {
      password = passwordController.text.trim();
    } else {
      password = "123456789";
    }

    if (password!.isNotEmpty) {
      if (selectedImage != null) {
        setState(() {
          isDecoding = true;
        });
        // decodedMessage = await Decode.decode_image_with_message(selectedImage!);
        decodedMessage = await compute(getDecodedMessage, {
          'image': selectedImage!,
        });

        ///gettign AES keys
        String aesKey = await keyGenFunc(keyLength: 256, password: password!);
        String aesIV = await keyGenFunc(keyLength: 128, password: password!);

        /// Decrypting message

        String decryptedMessage = await compute(decryptMessage, {
          "aesKey": aesKey,
          "aesIV": aesIV,
          "decodedMessage": decodedMessage,
        });

        /// decodedMessage ni UI da ham o'zgartirib chiqmaslik uchun uni decryptedMessage ga tenglashtirib qo'ydim
        setState(() {
          decodedMessage = decryptedMessage;
        });
        try {
          decodedFile = await compute(getDecodedFile, {
            'image': selectedImage!,
          });

          /// converting File to Encrypted data type
          MyEncrypt.Encrypted encr = readEncryptedFromFile(decodedFile!.path);

          /// Decrypting file
          DecryptWithAES decryptWithAESFile = DecryptWithAES.file(
              aesKey: aesKey, aesIV: aesIV, encryptedFile: encr);
          List<int> lst = decryptWithAESFile.decryptFile();

          /// kengaytmani ajratib olish
          int extensionNumber = lst.last;
          String? extension = extensions[extensionNumber];
          if (extensions.containsKey(extensionNumber)) lst.removeLast();
          File decryptedFile = await createFileFromBytes(
              fileBytes: lst, fileExtension: extension!);

          decodedFile = decryptedFile;

          if (decodedFile != null) {
            decodedFileName = mypath.basename(decodedFile!.path).toString();
          }
          _save();

          setState(() {
            isDecoding = false;
          });
        } catch (e) {
          /// yashirilgan ma'lumot fayl yoki matn ekanligi quyidagi qator orqali tekshirildi
          dataTypeController.changeToTrue();
          setState(() {
            isDecoding = false;
          });
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

  void _save() async {
    setState(() {
      isSaving = true;
    });
    _path = await ImageSaver()
        .saveDecodedFileToLocalFolder(decodedFile!, decodedFileName!);
    log("File type is: ${mypath.extension(decodedFile!.path).toLowerCase()}");
    setState(() {
      isSaving = false;
    });

    Get.snackbar("File saved to".tr(), _path!,
        colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
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
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          isDecoding
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator())
              : const SizedBox.shrink(),
          isSaving
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),
          selectedImage == null
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
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
                                  child: Image.file(
                                    height: 300,
                                    pickedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Decoded data:",
                          style: TextStyle(
                            color: color5,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      !dataTypeController.fileOrText.value
                          ? const SizedBox.shrink()
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: color4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            // overflow: TextOverflow.ellipsis,
                                            // maxLines: 5,
                                            textAlign: TextAlign.justify,
                                            decodedMessage.toString(),
                                            style: const TextStyle(
                                              color: color5,
                                              fontSize: 15,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 120,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      decodedFile != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        decodedFileName!,
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
        ],
      ),

      /// bottom part
      floatingActionButton: Container(
        width: double.infinity,
        height: 60,
        color: color4,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// attach file
            IconButton(
              onPressed: () async {
                _pickImage();
              },
              icon: const Icon(
                Icons.attach_file_outlined,
                color: color5,
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange),
              child: IconButton(
                /// decode file
                onPressed: () {
                  _decode();
                },
                icon: const Icon(
                  IconlyBold.unlock,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),

            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
