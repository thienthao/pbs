import 'package:customer_app_java_support/models/comment_bloc_model.dart';
import 'package:flutter/material.dart';

import 'comment.dart';

class CommentShow extends StatefulWidget {
  final List<CommentBlocModel> blocComments;

  const CommentShow({this.blocComments});
  @override
  _CommentShowState createState() => _CommentShowState();
}

class _CommentShowState extends State<CommentShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 2.0,
            child: Column(
              children:
                  widget.blocComments.asMap().entries.map((MapEntry mapEntry) {
                if (widget.blocComments[mapEntry.key] !=
                    widget.blocComments[widget.blocComments.length - 1]) {
                  return Column(
                    children: [
                      CommentWidget(
                        comment: widget.blocComments[mapEntry.key],
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
                        comment: widget.blocComments[mapEntry.key],
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
                        color: Color(0xFFF77474), fontWeight: FontWeight.w700),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
