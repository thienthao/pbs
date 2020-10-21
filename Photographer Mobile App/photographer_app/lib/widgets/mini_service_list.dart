import 'package:flutter/material.dart';

class MiniList extends StatefulWidget {
  @override
  _MiniListState createState() => _MiniListState();
}

class _MiniListState extends State<MiniList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Dịch vụ của bạn ...', style: TextStyle(
              fontSize: 15.0,
            ),),
            trailing: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.close,
                color: Colors.pink,
                size: 15.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
