import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as MyEncrypt;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as mypath;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stenography/data/repositories/extensions.dart';
import 'package:stenography/service/create_folder.dart';
import '../../encrypt/decrypt.dart';
import '../../encrypt/key_generation.dart';
import '../../service/hive_service.dart';
import '../../service/image_saver.dart';
import '../../steno/decode.dart';
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
  late AnimationController _controller;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordIsVisible = true;

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pickedImage!.path}')),
    );
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
    final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('${folder!.path}/$uniqueFileName.$fileExtension');
    file.writeAsBytesSync(fileBytes);
    return file;
  }

  void _decode() async {
    setState(() {
      isDecoding = true;
    });
    decodedMessage = await Decode.decode_image_with_message(selectedImage!);
    String password = passwordController.text.trim();
    if (password.isNotEmpty) {
      ///gettign AES keys
      String aesKey = await keyGenFunc(keyLength: 256, password: password);
      String aesIV = await keyGenFunc(keyLength: 128, password: password);

      /// Decrypting message
      DecryptWithAES decryptWithAES = DecryptWithAES.text(
          aesKey: aesKey, aesIV: aesIV, cipherText: decodedMessage);
      String decryptedMessage = decryptWithAES.decryptMessage();

      /// decodedMessage ni UI da ham o'zgartirib chiqmaslik uchun uni decryptedMessage ga tenglashtirib qo'ydim
      setState(() {
        decodedMessage = decryptedMessage;
      });

      decodedFile = await Decode.decode_image_with_file(selectedImage!);

      /// converting File to Encrypted data type
      MyEncrypt.Encrypted encr = readEncryptedFromFile(decodedFile!.path);

      /// Decrypting file
      DecryptWithAES decryptWithAESFile = DecryptWithAES.file(
          aesKey: aesKey, aesIV: aesIV, encryptedFile: encr);
      List<int> lst = decryptWithAESFile.decryptFile();
      int extensionNumber = lst.last;
      String? extension = extensions[extensionNumber];
      lst.removeLast();
      File decryptedFile =
          await createFileFromBytes(fileBytes: lst, fileExtension: extension!);
      decodedFile = decryptedFile;

      if (decodedFile != null) {
        decodedFileName = mypath.basename(decodedFile!.path).toString();
      }

      setState(() {
        isDecoding = false;
      });
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File saved to: $_path'),
      ),
    );
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
          Container(
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
          ),
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
                                    pickedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              isDecoding
                                  ? const Text(
                                      "Waiting...",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ).tr()
                                  : const SizedBox.shrink(),
                              isSaving
                                  ? const CircularProgressIndicator()
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      decodedMessage!.isEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                          "DECODED MSG: ${decodedMessage!}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ).tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                    ],
                  ),
                ),
        ],
      ),

      /// bottom part
      floatingActionButton: Container(
        width: double.infinity,
        height: 60,
        color: const Color(0xff3F4E4F),
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
                color: Color(0xffDCD7C9),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.blue),
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
            IconButton(
              onPressed: () async {
                _save();
              },
              icon: const Icon(
                Icons.save_alt,
                color: Colors.blue,
              ),
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
