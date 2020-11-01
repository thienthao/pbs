import 'package:customer_app_1_11/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 

class CommentWidget extends StatelessWidget {
  final Comment comment;
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
                  backgroundImage: AssetImage(comment.avatar),
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
                              rating: comment.rating,
                              size: 15.0,
                              isReadOnly: true,
                              defaultIconData: Icons.star_border,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: Colors.amber,
                              borderColor:  Colors.amber,
                              spacing: 0.0),
                          Text(
                            comment.dateCreated,
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
                                text: comment.commentorName,
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
                                text: comment.location,
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
                      text: comment.comment,
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
