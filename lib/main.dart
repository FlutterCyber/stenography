import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stenography/ui/pages/all_encoded_images.dart';
import 'package:stenography/ui/pages/encoded_images_with_file_page.dart';
import 'package:stenography/ui/pages/encoded_images_with_message_page.dart';
import 'package:stenography/ui/pages/home_page.dart';
import 'calc/bindings/my_bindings.dart';
import 'calc/screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('uz', 'UZ'),
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ru', 'RU'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: "Flutter Calculator",
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MainScreen(),
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
