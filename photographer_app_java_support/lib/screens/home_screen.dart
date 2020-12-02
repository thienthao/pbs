import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:photographer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';
import 'package:photographer_app_java_support/widgets/home/build_pen_task.dart';
import 'package:photographer_app_java_support/widgets/home/build_task.dart';
import 'package:photographer_app_java_support/widgets/home/show_calendar.dart';
import 'package:photographer_app_java_support/widgets/shared/list_booking_loading.dart';
import 'package:photographer_app_java_support/widgets/shared/loading_line.dart';

import 'vacation_screens/list_vacation_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());

  String filterType = 'Đang chờ';
  Completer<void> _completer;
  String _selectedDate;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _completer = Completer<void>();
    _loadPendingBookings();
    _loadCalendar();
  }

  _loadCalendar() async {
    BlocProvider.of<CalendarBloc>(context)
        .add(CalendarEventPhotographerDaysFetch(ptgId: 168));
  }

  _loadPendingBookings() async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventFetchByStatusPending());
  }

  _loadBookingsByDate(String _date) async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventFetchByDate(date: _date));
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
                  MaterialPageRoute(builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => WorkingDayBloc(
                              calendarRepository: _calendarRepository)
                            ..add(WorkingDayEventFetch(ptgId: 168)),
                        ),
                        BlocProvider(
                          create: (context) => BusyDayBloc(
                              calendarRepository: _calendarRepository),
                        ),
                      ],
                      child: ListVacation(),
                    );
                  }),
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
                      BlocBuilder<CalendarBloc, CalendarState>(
                        builder: (context, state) {
                          if (state is CalendarStateLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is CalendarStateFailure) {
                            return Center(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  'Đã xảy ra lỗi trong lúc tải dữ liệu \n Ấn để thử lại',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red[300], fontSize: 16),
                                ),
                              ),
                            );
                          }

                          if (state is CalendarStatePhotographerDaysSuccess) {
                            return CalendarShow(
                              photographerDays: state.photographerDays,
                              onSelectedDate: (String date) {
                                _selectedDate = date;
                                print('$date is selected');
                                _loadBookingsByDate(_selectedDate);
                              },
                            );
                          }
                          return Text('');
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: LoadingLine(),
                                );
                              }

                              if (bookingState is BookingStateFailure) {
                                return InkWell(
                                  onTap: () {
                                    _loadBookingsByDate(_selectedDate);
                                  },
                                  child: Text(
                                    'Đã xảy ra lỗi khi tải dữ liệu\n Ấn để thử lại',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red[300], fontSize: 16),
                                  ),
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
                            return Center(
                              child: Text(
                                'Hiện tại bạn chưa có lịch hẹn nào',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
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
                                  isEdited: (bool isEdited) {
                                    if (isEdited) {
                                      _loadPendingBookings();
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                        }

                        if (bookingState is BookingStateLoading) {
                          return ListBookingLoadingWidget();
                        }

                        if (bookingState is BookingStateFailure) {
                          return InkWell(
                            onTap: () {
                              _loadPendingBookings();
                            },
                            child: Text(
                              'Đã xảy ra lỗi khi tải dữ liệu\n Ấn để thử lại',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red[300], fontSize: 16),
                            ),
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
