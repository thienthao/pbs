import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
