import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:photographer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/thread_model.dart';

class EditThreadScreen extends StatefulWidget {
  final Thread thread;
  final Function(bool) isEdited;

  EditThreadScreen({this.thread, this.isEdited});

  @override
  _EditThreadScreenState createState() => _EditThreadScreenState();
}

class _EditThreadScreenState extends State<EditThreadScreen> {
  List<File> _images = [];

  TextEditingController threadTitle = TextEditingController();
  TextEditingController threadContent = TextEditingController();
  final threadTitleFocusNode = FocusNode();
  final threadContentFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  editThread() async {
    _unFocus();
    String title = threadTitle.text.toString();
    String content = threadContent.text.toString();
    Owner owner = Owner(id: globalPtgId);
    Thread thread = Thread(
        id: widget.thread.id,
        title: title,
        content: content,
        topic: widget.thread.topic,
        owner: owner,
        updatedAt: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()));
    // print('${thread.title} ${thread.content}');
    BlocProvider.of<ThreadBloc>(context).add(EditThread(thread: thread));
  }

  String _checkEmpty(String value) {
    if (value.isEmpty) {
      return 'Không thể bỏ trống trường này!';
    }
    return null;
  }

  _unFocus() {
    threadTitleFocusNode.unfocus();
    threadContentFocusNode.unfocus();
  }

  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Gallery,
    );
    setState(() {
      _images.add(image);
    });
  }

  @override
  void initState() {
    super.initState();
    threadTitle.text = widget.thread.title;
    threadContent.text = widget.thread.content;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThreadBloc, ThreadState>(
      listener: (context, state) {
        if (state is ThreadEmpty ||
            state is ThreadLoaded ||
            state is ThreadLoading) {
          _showLoadingAlert();
        }
        if (state is ThreadSuccess) {
          // Navigator.pop(context);
          widget.isEdited(true);
          Navigator.pop(context);
          _showSuccessAlert();
        }

        if (state is ThreadError) {
          Navigator.pop(context);
          _showFailDialog();
          print(state.error);
        }
      },
      child: Scaffold(
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
            IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.blue,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  editThread();
                }
              },
            ),
          ],
          title: Text('Chỉnh sửa bài đăng'),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      'Chủ đề:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Chip(
                      label: Text(widget.thread.topic.topic),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.5,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  focusNode: threadTitleFocusNode,
                  validator: _checkEmpty,
                  controller: threadTitle,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Tên bài đăng',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0.5,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  controller: threadContent,
                  focusNode: threadContentFocusNode,
                  validator: _checkEmpty,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Nội dung...',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              Divider(
                height: 0.5,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
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
                'Chỉnh sửa thành công',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
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
