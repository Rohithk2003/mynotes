import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, contentText, String titleText,
    String buttonText, Function handleFunction) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
                onPressed: () {
                  handleFunction();
                },
                child: Text(buttonText))
          ],
        );
      });
}
