import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:customer_app_java_support/screens/album_screens/album_detail_screen.dart';
import 'package:customer_app_java_support/screens/album_screens/more_album_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AlbumCarousel extends StatefulWidget {
  final List<AlbumBlocModel> blocAlbums;
  final Function(bool) onUpdateAlbum;
  AlbumCarousel({@required this.blocAlbums, this.onUpdateAlbum});
  @override
  _AlbumCarouselState createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends State<AlbumCarousel> {
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  Random _random = new Random();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Album được đánh giá cao',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: -1,
                  color: Colors.black54,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 1000),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation,
                            Widget child) {
                          animation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.fastLinearToSlowEaseIn);
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation) {
                          return BlocProvider(
                              create: (context) =>
                                  AlbumBloc(albumRepository: _albumRepository),
                              child: MoreAlbumScreen());
                        })),
                child: Text(
                  'Xem thêm',
                  style: TextStyle(
                    wordSpacing: -1,
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: const EdgeInsets.only(left: 20.0, right: 300.0),
          height: 3.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Container(
            height: 400.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.blocAlbums.length,
              itemBuilder: (BuildContext context, int index) {
                AlbumBlocModel blocAlbum = widget.blocAlbums[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secAnimation,
                              Widget child) {
                            animation = CurvedAnimation(
                                parent: animation, curve: Curves.easeInOutBack);
                            return ScaleTransition(
                                scale: animation,
                                child: child,
                                alignment: Alignment.center);
                          },
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secAnimation) {
                            return BlocProvider(
                              create: (context) =>
                                  AlbumBloc(albumRepository: _albumRepository),
                              child: ImageFullScreen(
                                album: blocAlbum,
                              ),
                            );
                          })).then((value) => widget.onUpdateAlbum(true)),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    height: 400,
                    width: 240.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0)
                              ]),
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: blocAlbum.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    height: 400,
                                    width: 240,
                                    fit: BoxFit.cover,
                                    imageUrl: blocAlbum.thumbnail,
                                    placeholder: (context, url) => Container(
                                        width: 240,
                                        height: 400,
                                        color: Colors.white,
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 54,
                                          color: Colors.black54,
                                        )),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15.0,
                                top: 15.0,
                                child: Text(
                                  blocAlbum.location == 'null'
                                      ? ''
                                      : '${blocAlbum.location}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(1, 3), blurRadius: 6)
                                      ]),
                                ),
                              ),
                              Positioned(
                                right: 15.0,
                                top: 15.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          blocAlbum.photographer.avatar),
                                    ),
                                    Text(
                                      blocAlbum.photographer.fullname ??
                                          'Ẩn danh',
                                      style: TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              offset: Offset(1, 3),
                                              blurRadius: 6)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 15.0,
                                bottom: 15.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.54,
                                          child: Text(
                                            '${blocAlbum.name}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 1.2,
                                                shadows: [
                                                  Shadow(
                                                      offset: Offset(1, 3),
                                                      blurRadius: 6)
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      blocAlbum.category.category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        shadows: [
                                          Shadow(
                                              offset: Offset(1, 3),
                                              blurRadius: 6)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 15.0,
                                bottom: 15.0,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite,
                                      size: 20.0,
                                      color: Colors.pinkAccent,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      blocAlbum.likes == null
                                          ? _random.nextInt(30).toString()
                                          : '${blocAlbum.likes}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        shadows: [
                                          Shadow(
                                              offset: Offset(1, 3),
                                              blurRadius: 6)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
