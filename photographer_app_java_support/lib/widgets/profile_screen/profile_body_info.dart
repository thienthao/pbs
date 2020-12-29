import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:photographer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';

class Info extends StatefulWidget {
  final Photographer photographer;

  const Info({this.photographer});
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
      if (image != null) {
        _cover = image;
        _updateCover();
      }
    });
  }

  _updateAvatar() async {
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventOnChangeAvatar(image: _avatar));
  }

  _updateCover() async {
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventOnChangeCover(image: _cover));
  }

  Widget _body() {
    return Stack(
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
                : Image.network(
                    widget.photographer.cover ??
                        'https://atlasadventuretravel.com/wp-content/uploads/2018/03/events-placeholder.jpg',
                    fit: BoxFit.cover,
                    headers: {
                      HttpHeaders.authorizationHeader: 'Bearer $globalPtgToken'
                    },
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
                                widget.photographer.avatar ??
                                    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                headers: {
                                  HttpHeaders.authorizationHeader:
                                      'Bearer $globalPtgToken'
                                },
                              ),
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
                widget.photographer.fullname ?? widget.photographer.username,
                style: TextStyle(
                  fontSize: 22.0, // 22
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.0), //5
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Lượt thích',
                  //       style: TextStyle(
                  //         color: Colors.black54,
                  //       ),
                  //     ),
                  //     SizedBox(height: 5.0),
                  //     Text(
                  //       '250',
                  //       style: TextStyle(
                  //         color: Colors.black54,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: [
                      Text(
                        'Đánh giá',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        widget.photographer.ratingCount != null
                            ? '${widget.photographer.ratingCount} ★'
                            : '0.0 ★',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Lượt đặt',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        widget.photographer.bookedNumber == null
                            ? '12'
                            : '${widget.photographer.bookedNumber}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390.0,
      child: _body(),
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
