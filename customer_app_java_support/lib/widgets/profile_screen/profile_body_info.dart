import 'dart:io';
import 'package:customer_app_java_support/blocs/customer_blocs/customers.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class Info extends StatefulWidget {
  final CustomerBlocModel customer;

  const Info({this.customer});
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  File _avatar;
  File _cover;

  Future getAvatar(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
    );

    setState(() {
      if (image != null) {
        _avatar = image;

        _updateAvatar();
      }
    });
  }

  Future getCover(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
    );
    setState(() {
      _cover = image;
    });
  }

  _updateAvatar() async {
    BlocProvider.of<CustomerBloc>(context)
        .add(CustomerEventUpdateAvatar(cusId: globalCusId, image: _avatar));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 290.0,
              width: double.infinity,
              color: Theme.of(context).accentColor,
              child: _cover != null
                  ? Image.file(
                      _cover,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/covers/IMG_0051.JPG',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt_rounded),
                  iconSize: 20.0,
                  color: Colors.white,
                  onPressed: () => getCover(ImgSource.Gallery),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0), //10
                      height: 140.0, //140
                      width: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 8.0, //8
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _avatar != null
                              ? FileImage(_avatar)
                              : NetworkImage(
                                  widget.customer.avatar ??
                                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                  headers: {
                                      HttpHeaders.authorizationHeader:
                                          'Bearer $globalCusToken'
                                    }),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 100.0, top: 100.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () => getAvatar(ImgSource.Gallery),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.customer.fullname ?? '${widget.customer.username}',
                  style: TextStyle(
                    fontSize: 22.0, // 22
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20.0), //5
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
