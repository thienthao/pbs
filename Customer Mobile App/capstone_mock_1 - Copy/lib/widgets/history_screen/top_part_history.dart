import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customshapeclipper.dart';
import 'drop_menu_history.dart';

class TopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFF88F8F),
                Color(0xFFF88Fa9),
              ]),
            ),
            height: 120.0,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          height: 54.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
          child: DropMenu(),
        ),
      ],
    );
  }
}
