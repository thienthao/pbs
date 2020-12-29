import 'dart:async';

import 'package:customer_app_java_support/blocs/album_blocs/album.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/photographer_blocs/photographers.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/respositories/album_respository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:customer_app_java_support/respositories/package_repository.dart';
import 'package:customer_app_java_support/respositories/photographer_respository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/photographer_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MorePtgScreen extends StatefulWidget {
  @override
  _MorePtgScreenState createState() => _MorePtgScreenState();
}

class _MorePtgScreenState extends State<MorePtgScreen> {
  PhotographerRepository _photographerRepository =
      PhotographerRepository(httpClient: http.Client());
  AlbumRepository _albumRepository = AlbumRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 0.0;
  bool _hasReachedEnd;
  Completer<void> _completer;
  @override
  void initState() {
    super.initState();
    _loadPhotographerInfinite();
    _completer = Completer<void>();

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreshold) {
        _loadPhotographerInfinite();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _loadPhotographerInfinite() {
    BlocProvider.of<PhotographerBloc>(context)
        .add(PhotographerEventFetchInfinite());
  }

  Widget listPhotographers(List<Photographer> _photographers) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:
          _hasReachedEnd ? _photographers.length : _photographers.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= _photographers.length) {
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
          Photographer ptg = _photographers[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => PhotographerBloc(
                          photographerRepository: _photographerRepository)
                        ..add(PhotographerbyIdEventFetch(id: ptg.id)),
                    ),
                    BlocProvider(
                      create: (context) =>
                          AlbumBloc(albumRepository: _albumRepository)
                            ..add(AlbumByPhotographerIdEventFetch(id: ptg.id)),
                    ),
                    BlocProvider(
                      create: (context) => PackageBloc(
                          packageRepository: _packageRepository)
                        ..add(PackageByPhotographerIdEventFetch(id: ptg.id)),
                    ),
                    BlocProvider(
                      create: (context) => CommentBloc(
                          commentRepository: _commentRepository)
                        ..add(CommentByPhotographerIdEventFetch(id: ptg.id)),
                    ),
                    BlocProvider(
                      create: (context) => CalendarBloc(
                          calendarRepository: _calendarRepository)
                        ..add(
                            CalendarEventPhotographerDaysFetch(ptgId: ptg.id)),
                    ),
                  ],
                  child: CustomerPhotographerDetail(
                    id: ptg.id,
                    name: ptg.fullname,
                  ),
                ),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          child: Text(
                            ptg.fullname,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {},
                                starCount: 5,
                                rating: ptg.ratingCount ?? 0.0,
                                size: 15.0,
                                isReadOnly: true,
                                defaultIconData: Icons.star_border,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                color: Colors.amber,
                                borderColor: Colors.amber,
                                spacing: 0.0),
                            SizedBox(width: 10.0),
                            Text('|'),
                            SizedBox(width: 10.0),
                            Text(
                              ptg.booked == null ? '0' : ptg.booked.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 3.0),
                            Text(
                              'đã đặt',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                ptg.description == null || ptg.description == ''
                                    ? 'Chưa có mô tả'
                                    : ptg.description,
                                maxLines: 4,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20.0,
                  top: 15.0,
                  bottom: 15.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      width: 110.0,
                      image: NetworkImage(
                        ptg.avatar == 'null'
                            ? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'
                            : ptg.avatar,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
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
          'Danh sách Photographer',
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
                child: Text("Được đặt nhiều"),
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
          // TopPartPtg(),

          Expanded(
            child: BlocBuilder<PhotographerBloc, PhotographerState>(
                builder: (context, photographerState) {
              //     if (photographerState is PhotographerStateLoading) {
              //   return Center(
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1.5,
              //     ),
              //   );
              // }
              if (photographerState
                  is PhotographerStateInifiniteFetchedSuccess) {
                if (photographerState.photographers.isEmpty) {
                  return Text(
                    'Hiện tại hệ thống chưa có photographer nào',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                } else {
                  _hasReachedEnd = photographerState.hasReachedEnd;
                  return RefreshIndicator(
                    onRefresh: () {
                      BlocProvider.of<PhotographerBloc>(context)
                          .add(PhotographerRestartEvent());
                      _loadPhotographerInfinite();
                      return _completer.future;
                    },
                    child: Container(
                      child: listPhotographers(photographerState.photographers),
                    ),
                  );
                }
              }

              if (photographerState is PhotographerStateLoading) {
                return Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (photographerState is PhotographerStateFailure) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã xảy ra lỗi khi tải dữ liệu',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          _loadPhotographerInfinite();
                        },
                        child: Text(
                          'Nhấn để tải lại',
                          style:
                              TextStyle(color: Colors.red[300], fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }
              // final bookings = (photographerState as BookingStateSuccess).bookings;
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
