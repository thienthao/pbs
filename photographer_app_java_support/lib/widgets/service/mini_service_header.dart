import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MiniHeader extends StatelessWidget {
  var txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: txtController,
            decoration: InputDecoration(
                labelText: 'Thêm dịch vụ',
                labelStyle: TextStyle(
                  fontSize: 13.0,
                ),
                hintText: 'Thêm...',
                hintStyle: TextStyle(
                  fontSize: 13.0,
                )),
          ),
        ),
        SizedBox(width: 20.0),
        IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: Colors.pink,
              size: 25.0,
            ),
            onPressed: null)
      ],
    );
  }
}
