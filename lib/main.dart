import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stenography/pages/all_encoded_images.dart';
import 'package:stenography/pages/encoded_images_with_file_page.dart';
import 'package:stenography/pages/home_page.dart';
import 'package:stenography/pages/encoded_images_with_message_page.dart';



void main() async {
  await Hive.initFlutter();
  await Hive.openBox("aesKey");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        AllEncodedImages.id: (context) => const AllEncodedImages(),
        EncodedImagesWithMessagePage.id: (context) =>
            const EncodedImagesWithMessagePage(),
        EncodedImagesWithFilePage.id: (context) =>
            const EncodedImagesWithFilePage(),
      },
    );
  }
}
