import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/widgets/customshapeclipper.dart';
import 'package:photographer_app_java_support/widgets/history/booking_widget.dart';
import 'package:photographer_app_java_support/widgets/history/drop_menu_history.dart';
import 'package:shimmer/shimmer.dart';

class BookHistory extends StatefulWidget {
  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  static const String AUTO_FIRST_STATUS = 'ALL';
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 0.0;
  String statusForFilter = 'ALL';
  bool isBookingEdited = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
    _loadBookingsByPaging(AUTO_FIRST_STATUS);

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreshold) {
        print('scroll on $statusForFilter');
        _loadBookingsByPaging(statusForFilter);
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    if (isBookingEdited) {
      _loadBookingsByPaging(AUTO_FIRST_STATUS);
      setState(() {});
    }
  }

  _loadBookingsByPaging(String _status) async {
    BlocProvider.of<BookingBloc>(context).add(BookingEventFetchInfinite(status: _status));
  }

  _restartEvent() async {
    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
  }

  Widget refreshData() {
    return Expanded(
      child: Center(
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            if (bookingState is BookingStateInitialPagingFetched) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              );
            }
            if (bookingState is BookingStateInfiniteFetchedSuccess) {
              if (bookingState.bookings.isEmpty) {
                return Text(
                  'Đà Lạt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () {
                    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
                    _loadBookingsByPaging(statusForFilter);
                    return _completer.future;
                  },
                  child: Container(
                    child: BookingWidget(
                      hasReachedEnd: bookingState.hasReachedEnd,
                      blocBookings: bookingState.bookings,
                      onGoBack: onGoBack,
                      isEdited: (bool _isEdited) {
                        isBookingEdited = _isEdited;
                      },
                      scrollController: _scrollController,
                    ),
                  ),
                );
              }
            }

            if (bookingState is BookingStateLoading) {
              return Shimmer.fromColors(
                period: Duration(milliseconds: 1100),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[500],
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  width: double.infinity,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 160.0,
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[400],
                                            Colors.grey[300],
                                          ], // whitish to gray
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 15.0,
                                    bottom: 15.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                          ),
                                          width: 100,
                                          height: 24,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                    BorderRadius.circular(1.0),
                                              ),
                                              width: 35,
                                              height: 15,
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
                      );
                    },
                  ),
                ),
              );
            }

            if (bookingState is BookingStateFailure) {
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
                      _loadBookingsByPaging(statusForFilter);
                    },
                    child: Text(
                      'Nhấn để tải lại',
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    ),
                  ),
                ],
              );
            }
            // final bookings = (bookingState as BookingStateSuccess).bookings;
            // return RefreshIndicator(
            //     child: Container(child: BookingWidget()),
            //     onRefresh: () {
            //       // BlocProvider.of<BookingBloc>(context)
            //       //     .add(BookingEventRefresh(booking: bookings[0]));
            //       return _completer.future;
            //     });
            return Text('Oh no!');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFFF88F8F),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFF88F8F),
              Color(0xFFF88Fa9),
            ]),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFF88F8F),
                      Color(0xFFF88Fa9),
                    ]),
                  ),
                  height: 120.0,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                height: 54.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 5,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                child: DropMenu(
                  onSelectParam: (String selectedStatus) {
                    print(selectedStatus.compareTo(statusForFilter));
                    if (selectedStatus == statusForFilter) {
                      statusForFilter = selectedStatus;
                      _loadBookingsByPaging(statusForFilter);
                    } else {
                      statusForFilter = selectedStatus;
                      _restartEvent();
                      _loadBookingsByPaging(statusForFilter);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          refreshData(),
        ],
      ),
    );
  }
}
