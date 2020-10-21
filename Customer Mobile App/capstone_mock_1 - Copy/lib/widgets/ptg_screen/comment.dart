import 'package:capstone_mock_1/models/comment_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CommentWidget extends StatelessWidget {
  final CommentBlocModel comment;
  const CommentWidget({this.comment});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.avatar),
                  radius: 28,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                print('You have rate $v stars');
                              },
                              starCount: 5,
                              rating:
                                  comment.rating == null ? 4.0 : comment.rating,
                              size: 15.0,
                              isReadOnly: true,
                              defaultIconData: Icons.star_border,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: Colors.amber,
                              borderColor: Colors.amber,
                              spacing: 0.0),
                          Text(
                            comment.createdAt == null
                                ? 'Date'
                                : DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(comment.createdAt)),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black54, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'bởi: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: comment.fullname == null
                                    ? 'Commentor'
                                    : comment.fullname,
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black54, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Địa điểm: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: comment.location == null
                                    ? 'Locaton'
                                    : comment.location,
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            RichText(
              text: TextSpan(
                text: '',
                style:
                    TextStyle(color: Colors.black54, fontFamily: 'Quicksand'),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Bình luận: ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          comment.comment == null ? 'Comment' : comment.comment,
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
