import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:customer_app_java_support/screens/ptg_screens/photographer_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:intl/intl.dart';
import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:customer_app_java_support/respositories/package_repository.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ImageFullScreen extends StatefulWidget {
  final AlbumBlocModel album;

  const ImageFullScreen({this.album});

  @override
  _ImageFullScreenState createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
  CardController controller;
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  int indexOfAlbum = 0;
  @override
  void initState() {
    super.initState();
    widget.album.images.length == 0 ? indexOfAlbum = 0 : indexOfAlbum = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          '${widget.album.name}',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => PhotographerBloc(
                                photographerRepository: _photographerRepository)
                              ..add(PhotographerbyIdEventFetch(
                                  id: widget.album.photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) =>
                                AlbumBloc(albumRepository: _albumRepository)
                                  ..add(AlbumByPhotographerIdEventFetch(
                                      id: widget.album.photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) => PackageBloc(
                                packageRepository: _packageRepository)
                              ..add(PackageByPhotographerIdEventFetch(
                                  id: widget.album.photographer.id)),
                          ),
                          BlocProvider(
                            create: (context) => CommentBloc(
                                commentRepository: _commentRepository)
                              ..add(CommentByPhotographerIdEventFetch(
                                  id: widget.album.photographer.id)),
                          ),
                        ],
                        child: CustomerPhotographerDetail(
                          id: widget.album.photographer.id,
                          name: widget.album.photographer.fullname,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10.0),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.album.photographer.avatar),
                      ),
                      SizedBox(width: 5.0),
                      Text(widget.album.photographer.fullname),
                    ],
                  ),
                ),
              ),
              Hero(
                tag: widget.album.id,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: new TinderSwapCard(
                      swipeUp: true,
                      swipeDown: false,
                      orientation: AmassOrientation.BOTTOM,
                      totalNum: widget.album.images.length,
                      stackNum: 4,
                      swipeEdge: 0.5,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.width * 1,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      minHeight: MediaQuery.of(context).size.width * 0.95,
                      cardBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              '${widget.album.images[index].imageLink}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      cardController: controller = CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        if (align.x < 0) {
                          //Card is LEFT swiping
                        } else if (align.x > 0) {
                          //Card is RIGHT swiping
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        setState(() {
                          if (indexOfAlbum < widget.album.images.length) {
                            indexOfAlbum = index + 2;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: indexOfAlbum.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: ' / ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: widget.album.images.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Wrap(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.chat_bubble_outline_outlined,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.share,
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                      text:
                          // '${oCcy.format(widget.album.likes)} lượt yêu thích ',
                          '209 lượt yêu thích',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[]),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'Quicksand'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Ngày chụp: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.album.createAt == null
                                  ? '20/12/2012'
                                  : '${widget.album.createAt}',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Thể loại: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '${widget.album.category.category}',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lens,
                      size: 5.0,
                    ),
                    SizedBox(width: 5.0),
                    RichText(
                      text: TextSpan(
                        text: '',
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'Quicksand'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Địa điểm: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '${widget.album.location}',
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(
                        color: Colors.black54, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Mô tả: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      TextSpan(
                        text: '${widget.album.description}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
