import 'package:flutter/material.dart';

class SliverItems extends StatefulWidget {
  @override
  _SliverItemsState createState() => _SliverItemsState();
}

class _SliverItemsState extends State<SliverItems> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/images/dalat.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 280.0,
          padding: EdgeInsets.only(
            left: 10.0,
            right: 20.0,
            top: 30.0,
          ),
          child: Text(
            'Bạn muốn chụp ảnh ở đâu?',
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            // overflow: TextOverflow.ellipsis,
            // maxLines: 2,
          ),
        ),
        Positioned(
          top: 105,
          left: 125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                icon: Icon(
                  Icons.edit_location,
                  color: Colors.white,
                ),
                label: Text(
                  'Đà Lạt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
