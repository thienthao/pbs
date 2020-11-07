import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptg_7_11_app/blocs/booking_blocs/bookings.dart';
import 'package:ptg_7_11_app/widgets/home/build_pen_task.dart';
import 'package:ptg_7_11_app/widgets/home/build_task.dart';
import 'package:ptg_7_11_app/widgets/home/show_calendar.dart';
import 'package:ptg_7_11_app/widgets/shared/loading_line.dart';

import 'vacation_screens/list_vacation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filterType = 'Đang chờ';
  Completer<void> _completer;
  String _selectedDate;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadPendingBookings();
  }

  _loadPendingBookings() async {
    context.bloc<BookingBloc>().add(BookingEventFetchByStatusPending());
  }

  _loadBookingsByDate(String _date) async {
    context.bloc<BookingBloc>().add(BookingEventFetchByDate(date: _date));
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
                        _loadPendingBookings();
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
                      CalendarShow(
                        onSelectedDate: (String date) {
                          _selectedDate = date;
                          print('$date is selected');
                          _loadBookingsByDate(_selectedDate);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: BlocBuilder<BookingBloc, BookingState>(
                            builder: (context, bookingState) {
                              if (bookingState
                                  is BookingStateFetchedByDateSuccess) {
                                if (bookingState.bookings.isEmpty) {
                                  return Text(
                                    'Không có hoạt động nào vào ngày này',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                } else {
                                  return RefreshIndicator(
                                    onRefresh: () {
                                      _loadBookingsByDate(_selectedDate);
                                      return _completer.future;
                                    },
                                    child: ListView(
                                      children: [
                                        BuildTask(
                                            blocBookings:
                                                bookingState.bookings),
                                      ],
                                    ),
                                  );
                                }
                              }

                              if (bookingState
                                  is BookingStateFetchByDateInProgress) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: LoadingLine(),
                                );
                              }

                              if (bookingState is BookingStateFailure) {
                                return Text(
                                  'Đã xảy ra lỗi khi tải dữ liệu',
                                  style: TextStyle(
                                      color: Colors.red[300], fontSize: 16),
                                );
                              }
                              return Text('');
                            },
                          ),
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
                                _loadPendingBookings();
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
                          return LoadingLine();
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
