import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCupertinoAlertDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Enter password').tr(),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel').tr(),
            onPressed: () {
              // Perform action when OK is pressed
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
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
