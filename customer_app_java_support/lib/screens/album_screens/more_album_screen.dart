import 'dart:async';
import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:customer_app_java_support/shared/loading_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'album_detail_screen.dart';

class MoreAlbumScreen extends StatefulWidget {
  @override
  _MoreAlbumScreenState createState() => _MoreAlbumScreenState();
}

class _MoreAlbumScreenState extends State<MoreAlbumScreen> {
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 0.0;
  bool _hasReachedEnd;
  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _loadAlbumsInfinite();
    _completer = Completer<void>();

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreshold) {
        _loadAlbumsInfinite();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _loadAlbumsInfinite() {
    BlocProvider.of<AlbumBloc>(context).add(AlbumEventFetchInfinite());
  }

  Widget listAlbums(List<AlbumBlocModel> _listAlbums) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      itemCount: _hasReachedEnd ? _listAlbums.length : _listAlbums.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= _listAlbums.length) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          AlbumBlocModel album = _listAlbums[index];
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
                      return ImageFullScreen(
                        album: album,
                      );
                    })),
            child: Container(
              margin: EdgeInsets.all(5.0),
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
                          tag: album.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image(
                              image: NetworkImage(album.thumbnail),
                              height: 230.0,
                              width: 330.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15.0,
                          top: 15.0,
                          child: Text(
                            album.location,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(offset: Offset(1, 3), blurRadius: 6)
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
                                backgroundImage:
                                    NetworkImage(album.photographer.avatar),
                              ),
                              Text(
                                album.photographer.fullname,
                                style: TextStyle(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
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
                              Text(
                                album.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(1, 3), blurRadius: 6)
                                    ]),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                album.category.category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
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
                                '${album.likes}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  shadows: [
                                    Shadow(offset: Offset(1, 3), blurRadius: 6)
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Album',
          style: TextStyle(
            fontSize: 20.0,
            letterSpacing: -1,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(
              Icons.sort,
              color: Colors.black87,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Được đánh giá cao"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Tải lên gần đây"),
              ),
            ],
          ),
        ],
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Color(0xFFF3F5F7),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: 10.0,
          // ),
          Expanded(
            child: BlocBuilder<AlbumBloc, AlbumState>(
                builder: (context, albumState) {
              //     if (albumState is AlbumStateLoading) {
              //   return Center(
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1.5,
              //     ),
              //   );
              // }
              if (albumState is AlbumStateInifiniteFetchedSuccess) {
                if (albumState.albums.isEmpty) {
                  return Text(
                    'Đà Lạt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                } else {
                  _hasReachedEnd = albumState.hasReachedEnd;
                  return RefreshIndicator(
                    onRefresh: () {
                      BlocProvider.of<AlbumBloc>(context)
                          .add(AlbumRestartEvent());
                      _loadAlbumsInfinite();
                      return _completer.future;
                    },
                    child: Container(
                      child: listAlbums(albumState.albums),
                    ),
                  );
                }
              }

              if (albumState is AlbumStateLoading) {
                return Wrap(
                  children: [
                    LoadingLine(),
                  ],
                );
              }

              if (albumState is AlbumStateFailure) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã xảy ra lỗi khi tải dữ liệu',
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        _loadAlbumsInfinite();
                      },
                      child: Text(
                        'Nhấn để tải lại',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      ),
                    ),
                  ],
                );
              }
              // final bookings = (albumState as BookingStateSuccess).bookings;
              // return RefreshIndicator(
              //     child: Container(child: BookingWidget()),
              //     onRefresh: () {
              //       // BlocProvider.of<BookingBloc>(context)
              //       //     .add(BookingEventRefresh(booking: bookings[0]));
              //       return _completer.future;
              //     });
              return Text('');
            }),
          ),
        ],
      ),
    );
  }
}
