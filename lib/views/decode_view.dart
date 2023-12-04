import 'dart:developer';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as mypath;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../encrypt/decrypt_text.dart';
import '../service/hive_service.dart';
import '../service/image_saver.dart';
import '../steno/decode.dart';
import '../service/image_picker.dart';

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

  void _decode() async {
    setState(() {
      isDecoding = true;
    });
    decodedMessage = await Decode.decode_image_with_message(selectedImage!);

    ///gettign AES keys
    String aesKey = HiveService.loadKey();
    String aesIV = HiveService.loadIV();

    /// Decrypting message
    DecryptWithAES decryptWithAES = DecryptWithAES(
        aesKey: aesKey, aesIV: aesIV, cipherText: decodedMessage);
    String decryptedMessage = decryptWithAES.decryptMessage();

    /// decodedMessage ni UI da ham o'zgartirib chiqmaslik uchun uni decryptedMessage ga tenglashtirib qo'ydim
    decodedMessage = decryptedMessage;
    decodedFile = await Decode.decode_image_with_file(selectedImage!);
    if (decodedFile != null) {
      decodedFileName = mypath.basename(decodedFile!.path).toString();
    }

    setState(() {
      isDecoding = false;
    });
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
                                    )
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
                                  child: Text(
                                    " DECODED MSG: ${decodedMessage!}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      decodedFile != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Flexible(
                                    child: Text(
                                      decodedFileName!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.teal,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),

          /// bottom part
          Container(
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
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue),
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
        ],
      ),
    );
  }
}
