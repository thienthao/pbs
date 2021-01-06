import 'package:customer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_repository.dart';
import 'package:customer_app_java_support/screens/forum_screen/edit_thread.dart';
import 'package:customer_app_java_support/screens/forum_screen/reply_screen.dart';
import 'package:customer_app_java_support/shared/scale_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';

class ForumDetail extends StatefulWidget {
  final Thread thread;
  final ThreadRepository threadRepository;
  final Function(bool) isPosted;

  ForumDetail({this.thread, this.threadRepository, this.isPosted});

  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  _deletePost() {
    BlocProvider.of<ThreadBloc>(context)
        .add(DeleteThread(id: widget.thread.id));
  }

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
                    isPosted: (bool _isPosted) {
                      if (_isPosted) {
                        widget.isPosted(true);
                      }
                    },
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
                elevation: 1.0,
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
                              DateFormat('dd/MM/yyyy hh:mm a').format(
                                  DateTime.parse(widget.thread.createdAt)),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 5.0),
                          widget.thread.owner.id == globalCusId
                              ? PopupMenuButton<int>(
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
                                      child: FlatButton(
                                        child: Text("Chỉnh sửa bài viết"),
                                        onPressed: () {
                                          scaleNavigator(
                                              context,
                                              MultiBlocProvider(
                                                providers: [
                                                  BlocProvider(
                                                    create: (context) =>
                                                        ThreadBloc(
                                                            repository: widget
                                                                .threadRepository),
                                                  ),
                                                ],
                                                child: EditThreadScreen(
                                                  thread: widget.thread,
                                                  isEdited: (bool isEdited) {
                                                    if (isEdited) {
                                                      widget.isPosted(true);
                                                    }
                                                  },
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: FlatButton(
                                          onPressed: () {
                                            _showConfirmAlert();
                                          },
                                          child: Text("Xóa bài viết")),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          BlocListener<ThreadBloc, ThreadState>(
                            listener: (context, state) {
                              if (state is ThreadSuccess) {
                                Navigator.pop(context);
                                widget.isPosted(true);
                                _showSuccessAlert();
                              }
                              if (state is ThreadLoading) {
                                _showLoadingAlert();
                              }
                              if (state is ThreadError) {
                                Navigator.pop(context);
                                _showFailDialog();
                              }
                            },
                            child: SizedBox(width: 10.0),
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
                  padding: EdgeInsets.only(top: 8.0),
                  child: Card(
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.0),
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
                                  DateFormat('dd/MM/yyyy hh:mm a').format(
                                      DateTime.parse(comment.createdAt)),
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            comment.comment,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => ReplyTo()),
                          //     );
                          //   },
                          //   child: Text(
                          //     'TRÍCH',
                          //     style: TextStyle(
                          //       fontSize: 14.0,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),
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

  Future<void> _showConfirmAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/question.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Xác nhận',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Bạn có chắc là muốn xóa bài viết này hay không?',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                _deletePost();
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: Theme.of(context).scaffoldBackgroundColor,
              buttonCancelText: Text(
                'Hủy bỏ',
                style: TextStyle(color: Colors.black87),
              ),
            ));
  }

  Future<void> _showSuccessAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/done_booking.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Hoàn thành',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Xoá bài viết thành công',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              onlyOkButton: true,
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }

  Future<void> _showLoadingAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) {
          return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Material(
                type: MaterialType.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                child: Image.asset(
                  'assets/images/loading_2.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  Future<void> _showFailDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Thất bại',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Đã có lỗi xảy ra trong lúc gửi yêu cầu.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
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
