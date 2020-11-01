import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photographer_app_1_11/blocs/booking_blocs/bookings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_1_11/widgets/home/build_pen_task.dart';
import 'package:photographer_app_1_11/widgets/home/build_task.dart';
import 'package:photographer_app_1_11/widgets/home/show_calendar.dart';
import 'package:shimmer/shimmer.dart';
import 'list_vacation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filterType = 'Đang chờ';
  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadBookings();
  }

  _loadBookings() async {
    context.bloc<BookingBloc>().add(BookingEventFetchByPending());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Lịch làm việc của tôi',
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: -2,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.calendar_today),
              color: Colors.black54,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListVacation()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        changeFilter('Đang chờ');
                      },
                      child: Text(
                        'Đang chờ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 4.0,
                      width: 120.0,
                      color: filterType == 'Đang chờ'
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        changeFilter('Việc cần làm');
                      },
                      child: Text(
                        'Việc cần làm',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 4.0,
                      width: 120.0,
                      color: filterType == 'Việc cần làm'
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          filterType == 'Việc cần làm'
              ? Expanded(
                  child: Column(
                    children: [
                      CalendarShow(),
                      Expanded(
                        child: ListView(
                          children: [
                            BuildTask(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
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
                                child: UpComSlidable(
                                  blocPendingBookings: bookingState.bookings,
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
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0.0, 2.0),
                                                    blurRadius: 6.0)
                                              ]),
                                          child: Stack(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.grey[400],
                                                        Colors.grey[300],
                                                      ], // whitish to gray
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.0),
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
                                                            BorderRadius
                                                                .circular(1.0),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[400],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        1.0),
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
                            style:
                                TextStyle(color: Colors.red[300], fontSize: 16),
                          );
                        }
                        final bookings =
                            (bookingState as BookingStateSuccess).bookings;
                        return RefreshIndicator(
                            child: Container(
                              child: UpComSlidable(),
                            ),
                            onRefresh: () {
                              // BlocProvider.of<BookingBloc>(context)
                              //     .add(BookingEventRefresh(booking: bookings[0]));
                              return _completer.future;
                            });
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }
}
