import 'package:cus_2_11_app/blocs/album_blocs/album.dart';
import 'package:cus_2_11_app/blocs/comment_blocs/comments.dart';
import 'package:cus_2_11_app/blocs/package_blocs/packages.dart';
import 'package:cus_2_11_app/blocs/photographer_blocs/photographers.dart';
import 'package:cus_2_11_app/models/photographer_bloc_model.dart';
import 'package:cus_2_11_app/respositories/album_respository.dart';
import 'package:cus_2_11_app/respositories/comment_repository.dart';
import 'package:cus_2_11_app/respositories/package_repository.dart';
import 'package:cus_2_11_app/respositories/photographer_respository.dart';
import 'file:///E:/Studies/flutter_study/cus_2_11_app/lib/screens/ptg_screens/more_ptg_screen.dart';
import 'file:///E:/Studies/flutter_study/cus_2_11_app/lib/screens/ptg_screens/photographer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PhotographCarousel extends StatefulWidget {
  final List<Photographer> blocPhotographers;

  PhotographCarousel({this.blocPhotographers});

  @override
  _PhotographCarouselState createState() => _PhotographCarouselState();
}

class _PhotographCarouselState extends State<PhotographCarousel> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
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
                'Photographer được đánh giá cao',
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
          margin: const EdgeInsets.only(left: 21.0, right: 300.0),
          height: 3.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0),
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
                                child: Image(
                                  image: NetworkImage(photographer.avatar),
                                  height: 240.0,
                                  width: 240.0,
                                  fit: BoxFit.cover,
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
                                          '${photographer.ratingCount}',
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
