import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:stenography/ui/pages/home_page.dart';
import '../../service/hive_service.dart';
import '../controller/calculate_controller.dart';
import '../controller/theme_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  var logger = Logger();

  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "9",
    "8",
    "7",
    "x",
    "6",
    "5",
    "4",
    "-",
    "3",
    "2",
    "1",
    "+",
    "0",
    ".",
    "ANS",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (context) {
      return Scaffold(
        backgroundColor: themeController.isDark
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        body: SafeArea(
          child: Column(
            children: [
              GetBuilder<CalculateController>(builder: (context) {
                return outPutSection(themeController, controller);
              }),
              inPutSection(themeController, controller),
            ],
          ),
        ),
      );
    });
  }

  /// In put Section - Enter Numbers
  Widget inPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                switch (index) {
                  /// CLEAR BTN
                  case 0:
                    return CustomAppButton(
                      buttonTapped: () {
                        controller.clearInputAndOutput();
                      },
                      buttonLongPressed: () {
                        Navigator.pushReplacementNamed(context, HomePage.id);
                      },
                      color: themeController.isDark
                          ? DarkColors.leftOperatorColor
                          : LightColors.leftOperatorColor,
                      textColor: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      text: buttons[index],
                    );

                  /// DELETE BTN
                  case 1:
                    return CustomAppButton(
                        buttonTapped: () {
                          controller.deleteBtnAction();
                        },
                        buttonLongPressed: () async {
                          // var smth = await keyGenFunc();
                          // logger.e(smth);
                          // String aesKey = HiveService.loadKey();
                          // String aesIV = HiveService.loadIV();
                          String aesIV = HiveService.loadKey();
                          List<int> bytes = utf8.encode(aesIV);
                          int lengthInBits = bytes.length * 8;
                          logger.e(lengthInBits);

                          // String aesKey = await keyGenFunc();
                          // logger.e(aesIV.length);
                          // logger.e(aesKey.length);
                        },
                        color: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        textColor: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        text: buttons[index]);

                  /// EQUAL BTN
                  case 19:
                    return CustomAppButton(
                        buttonTapped: () {
                          controller.equalPressed();
                        },
                        buttonLongPressed: () {},
                        color: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        textColor: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        text: buttons[index]);

                  default:
                    return CustomAppButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      buttonLongPressed: () {},
                      color: isOperator(buttons[index])
                          ? LightColors.operatorColor
                          : themeController.isDark
                              ? DarkColors.btnBgColor
                              : LightColors.btnBgColor,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : themeController.isDark
                              ? Colors.white
                              : Colors.black,
                      text: buttons[index],
                    );
                }
              }),
        ));
  }

  /// Out put Section - Show Result
  Widget outPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// theme switcher
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GetBuilder<ThemeController>(builder: (controller) {
            return AdvancedSwitch(
              controller: controller.switcherController,
              activeImage: const AssetImage('assets/day_sky.png'),
              inactiveImage: const AssetImage('assets/night_sky.jpg'),
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              activeChild: const Text(
                'Day',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              inactiveChild: const Text(
                'Night',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(1000)),
              width: 100.0,
              height: 45.0,
              enabled: true,
              disabledOpacity: 0.5,
            );
          }),
        ),
        Expanded(child: Container()),

        /// Main Result - user input and output
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  controller.userInput,
                  style: TextStyle(
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                      fontSize: 38),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  controller.userOutput,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeController.isDark ? Colors.white : Colors.black,
                    fontSize: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  /// is Operator Check
  bool isOperator(String y) {
    if (y == "%" || y == "/" || y == "x" || y == "-" || y == "+" || y == "=") {
      return true;
    }
    return false;
  }
}
