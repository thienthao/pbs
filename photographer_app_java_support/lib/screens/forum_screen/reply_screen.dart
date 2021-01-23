import 'dart:io';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/thread_model.dart';

// ignore: must_be_immutable
class Reply extends StatefulWidget {
  Thread thread;
  Function(bool) isPosted;

  Reply({this.thread, this.isPosted});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  List<File> _images = [];
  TextEditingController replyController = TextEditingController();

  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
    );
    setState(() {
      _images.add(image);
    });
  }

  void _postComment() {
    String reply = replyController.text;
    String createdAt = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
    Owner owner = Owner(id: globalPtgId);

    ThreadComment comment = ThreadComment(
        comment: reply,
        createdAt: createdAt,
        owner: owner,
        thread: widget.thread);
    BlocProvider.of<ThreadBloc>(context)
        .add(PostComment(threadComment: comment));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocListener<ThreadBloc, ThreadState>(
            listener: (context, state) {
              if (state is ThreadLoading) {
                _showLoadingAlert();
              }
              if (state is CommentSuccess) {
                // Navigator.pop(context);

                _showSuccessAlert();
                widget.isPosted(true);
              }
              if (state is CommentFailure) {
                // Navigator.pop(context);
                _showFailDialog();
              }
            },
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.blue,
              ),
              onPressed: () {
                _postComment();
              },
            ),
          ),
        ],
        title: Text('Trả lời'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: TextField(
              controller: replyController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Viết bình luận của bạn...',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 60.0),
        ],
      ),
    );
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
                'Gửi bình luận thành công',
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
