import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(0xFFF88F8F),
        accentColor: Color(0xFFFFBDAC),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
