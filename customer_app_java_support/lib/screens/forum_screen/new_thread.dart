import 'dart:io';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class NewThread extends StatefulWidget {
  final Topic topic;
  final Function(bool) isCreate;

  NewThread({this.topic, this.isCreate});

  @override
  _NewThreadState createState() => _NewThreadState();
}

class _NewThreadState extends State<NewThread> {
  // function post
  // phai co blocprovider
  // tao texteditingcontroller
  // Thread thread =

  List<File> _images = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController threadTitle = TextEditingController();
  TextEditingController threadContent = TextEditingController();

  void post() {
    String title = threadTitle.text.toString();
    String content = threadContent.text.toString();
    int topicId = widget.topic.id;
    Topic topic = Topic(id: topicId);
    Owner owner = Owner(id: globalCusId);
    Thread thread = Thread(
        title: title,
        content: content,
        topic: topic,
        owner: owner,
        createdAt: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()));
    BlocProvider.of<ThreadBloc>(context).add(PostThread(thread: thread));
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
          widget.isCreate(true);
          _showSuccessAlert();
        }

        if (state is ThreadError) {
          Navigator.pop(context);
          _showFailDialog();
        }
      },
      child: Form(
        key: _formKey,
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
                    post();
                  }
                },
              ),
            ],
            title: Text('Chủ đề mới'),
            centerTitle: true,
            elevation: 2.0,
          ),
          body: ListView(
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
                      label: Text(widget.topic.topic),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Tiêu đề không thể để trống.';
                    }
                    return null;
                  },
                  controller: threadTitle,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Tên chủ đề',
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nội dung không thể để trống.';
                    }
                    return null;
                  },
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
              // Divider(
              //   height: 0.5,
              //   color: Colors.grey,
              // ),
              // SizedBox(height: 20.0),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //         'Hình ảnh',
              //         style: TextStyle(
              //           color: Colors.grey,
              //           fontSize: 16.0,
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () => getImage(),
              //         child: Container(
              //           margin: EdgeInsets.symmetric(vertical: 10.0),
              //           width: 100.0,
              //           height: 100.0,
              //           decoration: BoxDecoration(
              //             color: Colors.grey[300],
              //             borderRadius: BorderRadius.circular(10.0),
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(vertical: 10.0),
              //             child: Center(
              //               child: IconButton(
              //                 icon: Icon(
              //                   Icons.add,
              //                   color: Colors.black54,
              //                 ),
              //                 onPressed: () {},
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SingleChildScrollView(
              //         scrollDirection: Axis.vertical,
              //         child: Wrap(
              //           spacing: 7,
              //           runSpacing: 7,
              //           children: List.generate(_images.length, (index) {
              //             return Hero(
              //               tag: _images[index],
              //               child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(10.0),
              //                 child: Image(
              //                   image: FileImage(_images[index]),
              //                   width: 100,
              //                   height: 100,
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             );
              //           }),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                'Đăng bài thành công',
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
