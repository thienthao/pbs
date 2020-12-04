import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

void popNotice(BuildContext context) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: 60),
    title: 'Đang gửi yêu cầu',
    configuration: IconConfiguration(
      icon: Icons.send_to_mobile,
    ),
  );
}

void removeNotice() {
  StatusAlert.hide();
}

void popUp(BuildContext context, String title, String content) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.black87,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    isDismissible: false,
    duration: Duration(seconds: 5),
    titleText: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
          fontFamily: "Quicksand"),
    ),
    messageText: Text(
      content,
      style: TextStyle(
          fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
    ),
  ).show(context);
}
