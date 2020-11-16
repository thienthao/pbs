import 'dart:async';
import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/widgets/history_screen/booking_widget.dart';
import 'package:customer_app_java_support/widgets/history_screen/top_part_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
    // _loadBookingsByPaging(AUTO_FIRST_STATUS);

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreshold) {
        print('scroll on $statusForFilter');
        // _loadBookingsByPaging(statusForFilter);
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    if (isBookingEdited) {
      _loadBookings();
      setState(() {});
    }
  }

  _loadBookings() async {
    BlocProvider.of<BookingBloc>(context).add(BookingEventFetch());
  }

  Widget refreshData() {
    return Expanded(
      child: Center(
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            if (bookingState is BookingStateSuccess) {
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
                    _loadBookings();
                    return _completer.future;
                  },
                  child: Container(
                    child: BookingWidget(
                      blocBookings: bookingState.bookings,
                      onGoBack: onGoBack,
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
              return Text(
                'Đã xảy ra lỗi khi tải dữ liệu',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              );
            }
            return Text('');
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
          style: TextStyle(fontWeight: FontWeight.w600),
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
          //////////////////////////////////////////////////////// Filter
          TopPart(),
          ///////////////////////////////////////////////////////////////
          SizedBox(
            height: 20.0,
          ),
          refreshData(),
        ],
      ),
    );
  }
}
