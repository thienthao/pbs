import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:photographer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';
import 'package:photographer_app_java_support/widgets/home/build_pen_task.dart';
import 'package:photographer_app_java_support/widgets/home/build_task.dart';
import 'package:photographer_app_java_support/widgets/home/show_calendar.dart';
import 'package:photographer_app_java_support/widgets/shared/list_booking_loading.dart';
import 'package:photographer_app_java_support/widgets/shared/loading_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'vacation_screens/list_vacation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  DatabaseReference _notificationRef;
  String filterType = 'Chờ xác nhận';
  Completer<void> _completer;
  String _selectedDate;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _completer = Completer<void>();
    _loadPendingBookings();
    _loadCalendar();
  }

 

  getPreference() async {
    prefs = await SharedPreferences.getInstance();
    globalPtgId = prefs.getInt('photographerId');
    globalPtgToken = prefs.getString('photographerToken');
  }

  _loadCalendar() async {
    BlocProvider.of<CalendarBloc>(context)
        .add(CalendarEventPhotographerDaysFetch(ptgId: globalPtgId));
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
    _notificationRef = FirebaseDatabase.instance
        .reference()
        .child('Notification_$globalPtgId');
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
          StreamBuilder(
              stream: _notificationRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.data != null &&
                    snapshot.data.snapshot.value != null) {
                  _loadPendingBookings();
                  _loadCalendar();
                }

                return Padding(
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
                                    calendarRepository: _calendarRepository),
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
                );
              }),
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
                        changeFilter('Chờ xác nhận');
                        _loadPendingBookings();
                      },
                      child: Text(
                        'Chờ xác nhận',
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
                      color: filterType == 'Chờ xác nhận'
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
                                            isEdited: (bool isEdited) {
                                              if (isEdited) {
                                                _loadCalendar();
                                                _loadBookingsByDate(
                                                    _selectedDate);
                                              }
                                            },
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
                                return Center(
                                  child: InkWell(
                                    onTap: () {
                                      _loadBookingsByDate(_selectedDate);
                                    },
                                    child: Text(
                                      'Đã xảy ra lỗi khi tải dữ liệu\n Ấn để thử lại',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red[300], fontSize: 16),
                                    ),
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
                  child: BlocConsumer<BookingBloc, BookingState>(
                    listener: (context, state) {
                      if (state is BookingStateFailure) {
                        String error =
                            state.error.replaceAll('Exception: ', '');
                        if (error.toUpperCase() == 'UNAUTHORIZED') {
                          _showUnauthorizedDialog();
                        }
                      }
                    },
                    builder: (context, bookingState) {
                      if (bookingState is BookingStateSuccess) {
                        if (bookingState.bookings.isEmpty) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                _loadPendingBookings();
                              },
                              child: Text(
                                'Hiện tại bạn chưa có lịch hẹn nào',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            onRefresh: () {
                              _loadPendingBookings();
                              return _completer.future;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                child: UpComSlidable(
                                  blocPendingBookings: bookingState.bookings,
                                  isEdited: (bool isEdited) {
                                    if (isEdited) {
                                      _loadPendingBookings();
                                      _loadCalendar();
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      if (bookingState is BookingStateLoading) {
                        return ListBookingLoadingWidget();
                      }

                      if (bookingState is BookingStateFailure) {
                        return Center(
                          child: InkWell(
                            onTap: () {
                              _loadPendingBookings();
                            },
                            child: Text(
                              'Đã xảy ra lỗi khi tải dữ liệu\n Ấn để thử lại',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red[300], fontSize: 16),
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
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

  Future<void> _showUnauthorizedDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Thông báo',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Tài khoản không có quyền truy cập nội dung này!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
