import 'package:flutter/material.dart';

void scaleNavigator(BuildContext context, Widget widget) {
  Navigator.push(
      context,
      // MaterialPageRoute(
      //   builder: (_) => ImageFullScreen(image: item.imageUrl),
      // ),
      PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutBack);
            return ScaleTransition(
                scale: animation, child: child, alignment: Alignment.center);
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secAnimation) {
            return widget;
          }));
}
