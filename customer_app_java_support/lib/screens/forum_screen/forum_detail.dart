import 'package:customer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_repository.dart';
import 'package:customer_app_java_support/screens/forum_screen/reply_screen.dart';
import 'package:customer_app_java_support/screens/forum_screen/reply_to_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForumDetail extends StatefulWidget {
  final Thread thread;
  final ThreadRepository threadRepository;

  ForumDetail({this.thread, this.threadRepository});

  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          widget.thread.title,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      ThreadBloc(repository: widget.threadRepository),
                  child: Reply(
                    thread: widget.thread,
                  ),
                ),
              ));
        },
        child: Icon(
          Icons.reply,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Card(
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.thread.owner.avatar),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  widget.thread.owner.fullname,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.thread.createdAt,
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        widget.thread.title,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        widget.thread.content,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: [
                          Text(
                            'TRÍCH',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '·',
                            style:
                                TextStyle(fontSize: 11.0, color: Colors.grey),
                          ),
                          SizedBox(width: 5.0),
                          PopupMenuButton<int>(
                            child: Text(
                              'ĐIỀU HÀNH',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Chỉnh sửa bài viết"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Xóa bài viết"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.thread.comments.length,
              itemBuilder: (context, index) {
                ThreadComment comment = widget.thread.comments[index];
                return Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(comment.owner.avatar),
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      comment.owner.fullname,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  comment.owner.fullname,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            comment.comment,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReplyTo()),
                              );
                            },
                            child: Text(
                              'TRÍCH',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// Padding(
//   padding: EdgeInsets.only(top: 10.0),
//   child: Card(
//     elevation: 0.0,
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 5.0),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor:
//                           Theme.of(context).accentColor,
//                     ),
//                     SizedBox(width: 5.0),
//                     Text(
//                       'huyvc',
//                       style: TextStyle(
//                         fontSize: 13.0,
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   widget.thread.createdAt,
//                   style:
//                       TextStyle(fontSize: 12.0, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey, width: 0.3),
//               color: Theme.of(context).scaffoldBackgroundColor,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 10.0),
//                   child: Text(
//                     'quang3456:',
//                     style: TextStyle(
//                       fontSize: 11.0,
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                   height: 1.0,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 10.0),
//                   child: Text(
//                     'Tip này cũ rồi bro ơi',
//                     style: TextStyle(
//                       fontSize: 15.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Text(
//             'Mình vẫn thấy còn xài tốt mà bạn',
//             style: TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//           SizedBox(height: 15.0),
//           Text(
//             'TRÍCH',
//             style: TextStyle(
//               fontSize: 14.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
