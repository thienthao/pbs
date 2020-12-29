import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage("assets/images/logo.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
