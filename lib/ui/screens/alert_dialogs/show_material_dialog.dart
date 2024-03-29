import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showMaterialAlertDialog(BuildContext context) {
  bool passwordVisibility = true;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xff3F4E4F),
        title: const Text(
          'Enter password',
          style: TextStyle(color: Colors.white),
        ).tr(),
        content: Container(
          padding: const EdgeInsets.all(10),
          height: 60,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password",
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ).tr(),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            onPressed: () {
              // Perform action when OK is pressed
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
