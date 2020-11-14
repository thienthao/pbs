import 'dart:io';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_event.dart';
import 'package:customer_app_java_support/blocs/thread_bloc/thread_state.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class NewThread extends StatefulWidget {
  final Topic topic;

  NewThread({this.topic});

  @override
  _NewThreadState createState() => _NewThreadState();
}

class _NewThreadState extends State<NewThread> {
  // function post
  // phai co blocprovider
  // tao texteditingcontroller
  // Thread thread =

  List<File> _images = [];

  TextEditingController threadTitle = TextEditingController();
  TextEditingController threadContent = TextEditingController();

  void post() {
    String title = threadTitle.text.toString();
    String content = threadContent.text.toString();
    int topicId = widget.topic.id;
    Topic topic = Topic(id: topicId);
    Owner owner = Owner(id: 168);
    Thread thread = Thread(
        title: title,
        content: content,
        topic: topic,
        owner: owner,
        createdAt: "2020-11-08 12:12:12");
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
    return BlocBuilder<ThreadBloc, ThreadState>(
      builder: (context, state) {
        if (state is ThreadEmpty ||
            state is ThreadLoaded ||
            state is ThreadLoading) {
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
                IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    post();
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
                  child: TextField(
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
                  child: TextField(
                    controller: threadContent,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Bình luận của bạn...',
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hình ảnh',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => getImage(),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black54,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: List.generate(_images.length, (index) {
                            return Hero(
                              tag: _images[index],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  image: FileImage(_images[index]),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ThreadSuccess) {
          return (Center(child: Text("Post thanh cong")));
        }

        return Scaffold(
          body: Center(
            child: Text("Đã xảy ra lỗi"),
          ),
        );
      },
    );
  }
}
