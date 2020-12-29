import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void popNotice(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Material(
              type: MaterialType.card,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
              child: Image.asset(
                'assets/images/loading_2.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      });
}

void removeNotice(BuildContext context) {
  Navigator.of(context).pop();
}

void popUp(BuildContext context, String title, String content) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.grey[100],
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    isDismissible: false,
    duration: Duration(seconds: 5),
    titleText: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.black,
          fontFamily: "Quicksand"),
    ),
    messageText: Text(
      content,
      style: TextStyle(
          fontSize: 16.0, color: Colors.black, fontFamily: "Quicksand"),
    ),
  ).show(context);
}
