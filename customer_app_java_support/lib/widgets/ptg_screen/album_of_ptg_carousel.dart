import 'dart:io';

import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:customer_app_java_support/screens/album_screens/album_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AlbumOfPhotographerCarouselWidget extends StatefulWidget {
  final List<AlbumBlocModel> blocAlbums;
  final Function(bool) onUpdateAlbum;

  const AlbumOfPhotographerCarouselWidget(
      {this.blocAlbums, this.onUpdateAlbum});

  @override
  _AlbumOfPhotographerCarouselWidgetState createState() =>
      _AlbumOfPhotographerCarouselWidgetState();
}

class _AlbumOfPhotographerCarouselWidgetState
    extends State<AlbumOfPhotographerCarouselWidget> {
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.blocAlbums
        .map((item) => Hero(
              tag: item.id,
              child: Container(
                height: 1000,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //   builder: (_) => ImageFullScreen(image: item.imageUrl),
                        // ),
                        PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutBack);
                              return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                  alignment: Alignment.center);
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation) {
                              return BlocProvider(
                                create: (context) => AlbumBloc(
                                    albumRepository: _albumRepository),
                                child: ImageFullScreen(album: item),
                              );
                            })).then((value) {
                      return widget.onUpdateAlbum(true);
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0.0),
                          child: Center(
                            child: Image(
                              image: NetworkImage(
                                item.thumbnail,
                                headers: {
                                  HttpHeaders.authorizationHeader:
                                      'Bearer $globalCusToken'
                                },
                              ),
                              height: 460.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15.0,
                        right: 15.0,
                        top: 20.0,
                        child: Container(
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.location.toString() == 'null'
                                            ? ''
                                            : item.location.toString() ==
                                                    'Thành Phố Hồ Chí Minh'
                                                ? 'TP HCM'
                                                : item.location,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(1, 3),
                                                  blurRadius: 6)
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        item.createdAt == null
                                            ? '20/11/2019'
                                            : '${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.createdAt))}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(1, 3),
                                                  blurRadius: 6)
                                            ]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15.0,
                        right: 15.0,
                        bottom: 20.0,
                        child: Container(
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      padding: new EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        item.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w400,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(1, 3),
                                                  blurRadius: 6)
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        '${item.likes}  ',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(1, 3),
                                                  blurRadius: 6)
                                            ]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                item.category.category,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(1, 3), blurRadius: 6)
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 0.9,
                    enableInfiniteScroll:
                        imageSliders.length > 1 ? true : false,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
              ],
            )),
      ],
    );
  }
}
