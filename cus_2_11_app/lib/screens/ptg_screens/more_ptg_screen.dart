import 'dart:async';

import 'package:cus_2_11_app/blocs/album_blocs/album.dart';
import 'package:cus_2_11_app/blocs/comment_blocs/comments.dart';
import 'package:cus_2_11_app/blocs/package_blocs/packages.dart';
import 'package:cus_2_11_app/blocs/photographer_blocs/photographers.dart';
import 'package:cus_2_11_app/models/photographer_bloc_model.dart';
import 'package:cus_2_11_app/respositories/album_respository.dart';
import 'package:cus_2_11_app/respositories/comment_repository.dart';
import 'package:cus_2_11_app/respositories/package_repository.dart';
import 'package:cus_2_11_app/respositories/photographer_respository.dart';
import 'file:///E:/Studies/flutter_study/cus_2_11_app/lib/screens/ptg_screens/photographer_detail.dart';
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
      print(maxScrollExtent - currentScroll);
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
    context.bloc<PhotographerBloc>().add(PhotographerEventFetchInfinite());
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
          print(index);
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
                                rating: ptg.ratingCount,
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
                              '30',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 3.0),
                            Text(
                              'nhận xét',
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
                              Icons.location_on,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                'Địa điểm của photographer',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.attach_money_rounded,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                '~ Trung bình số tiền các package (chẳn hạn)',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        ptg.avatar,
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
                    'Đà Lạt',
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
                      context
                          .bloc<PhotographerBloc>()
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
                        _loadPhotographerInfinite();
                      },
                      child: Text(
                        'Nhấn để tải lại',
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                      ),
                    ),
                  ],
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
