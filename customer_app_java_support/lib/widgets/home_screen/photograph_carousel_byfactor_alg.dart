import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:customer_app_java_support/respositories/package_repository.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/more_ptg_screen.dart';
import 'package:customer_app_java_support/screens/ptg_screens/photographer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PhotographCarouselByFactorAlg extends StatefulWidget {
  final List<Photographer> blocPhotographers;

  PhotographCarouselByFactorAlg({this.blocPhotographers});

  @override
  _PhotographCarouselByFactorAlgState createState() =>
      _PhotographCarouselByFactorAlgState();
}

class _PhotographCarouselByFactorAlgState
    extends State<PhotographCarouselByFactorAlg> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
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
                'Photographer được gợi ý cho bạn',
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
                              create: (context) => PhotographerBloc(
                                  photographerRepository:
                                      _photographerRepository),
                              child: MorePtgScreen());
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
            height: 240.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.blocPhotographers.length,
              itemBuilder: (BuildContext context, int index) {
                Photographer photographer = widget.blocPhotographers[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => PhotographerBloc(
                                photographerRepository: _photographerRepository)
                              ..add(PhotographerbyIdEventFetch(
                                  id: photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) =>
                                AlbumBloc(albumRepository: _albumRepository)
                                  ..add(AlbumByPhotographerIdEventFetch(
                                      id: photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) => PackageBloc(
                                packageRepository: _packageRepository)
                              ..add(PackageByPhotographerIdEventFetch(
                                  id: photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) => CommentBloc(
                                commentRepository: _commentRepository)
                              ..add(CommentByPhotographerIdEventFetch(
                                  id: photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) => CalendarBloc(
                                calendarRepository: _calendarRepository)
                              ..add(CalendarEventPhotographerDaysFetch(
                                  ptgId: photographer.id)),
                          ),
                        ],
                        child: CustomerPhotographerDetail(
                          id: photographer.id,
                          name: photographer.fullname,
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: 240,
                                  height: 240,
                                  imageUrl: photographer.avatar ??
                                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                  httpHeaders: {
                                    HttpHeaders.authorizationHeader:
                                        'Bearer $globalCusToken'
                                  },
                                  placeholder: (context, url) => Container(
                                      width: 240,
                                      height: 240,
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
                              Positioned(
                                left: 15.0,
                                bottom: 15.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      photographer.fullname,
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
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.amberAccent,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 2.0),
                                        Text(
                                          photographer.ratingCount == null
                                              ? '0.0'
                                              : '${photographer.ratingCount}',
                                          style: TextStyle(
                                              color: Colors.amberAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 1.2,
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
