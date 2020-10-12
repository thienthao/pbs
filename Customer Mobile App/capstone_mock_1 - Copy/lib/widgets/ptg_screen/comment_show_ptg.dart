import 'package:capstone_mock_1/models/comment_model.dart';
import 'package:flutter/material.dart';

import 'comment.dart'; 

class CommentShow extends StatefulWidget {
  @override
  _CommentShowState createState() => _CommentShowState();
}

class _CommentShowState extends State<CommentShow> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Nhận xét',
              style:
              TextStyle(fontSize: 30.0, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 2.0,
            child: Column(
              children: comments.asMap().entries.map((MapEntry mapEntry) {
                if (comments[mapEntry.key] !=
                    comments[comments.length - 1]) {
                  return Column(
                    children: [
                      CommentWidget(
                        comment: comments[mapEntry.key],
                      ),
                      Divider(
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      CommentWidget(
                        comment: comments[mapEntry.key],
                      ),
                    ],
                  );
                }
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                GestureDetector(
                  child: Text(
                    'Xem thêm',
                    style: TextStyle(
                        color: Color(0xFFF77474),
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    print('Xem thêm is click');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
