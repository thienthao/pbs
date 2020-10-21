import 'package:flutter/material.dart';

class MiniListEdit extends StatefulWidget {
  @override
  _MiniListEditState createState() => _MiniListEditState();
}

class _MiniListEditState extends State<MiniListEdit> {
  final services = [
    'Free 01 áo dài hoặc trang phục tùy chọn',
    'Free Makeup, làm tóc',
    'Được chụp từ 150-200 file',
    'Photoshop 25 ảnh',
    'Tặng 10 ảnh ép lụa',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              services[index],
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
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
