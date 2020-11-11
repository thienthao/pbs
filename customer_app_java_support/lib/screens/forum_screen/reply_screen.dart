import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class Reply extends StatefulWidget {
  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  List<File> _images = [];

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
            onPressed: () => Navigator.pop(context),
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.black54,
                          ),
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
}