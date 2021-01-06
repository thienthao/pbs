import 'package:flutter/material.dart';

void slideNavigator(BuildContext context, Widget widget) {
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
            animation = CurvedAnimation(
                parent: animation, curve: Curves.fastLinearToSlowEaseIn);
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secAnimation) {
            return widget;
          }));
}
