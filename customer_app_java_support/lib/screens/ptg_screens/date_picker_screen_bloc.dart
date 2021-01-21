import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/calendar_model.dart';
import 'package:customer_app_java_support/plane_indicator.dart';
import 'package:customer_app_java_support/shared/datepicker_loading.dart';
import 'package:customer_app_java_support/shared/loading.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BlocDatePicker extends StatefulWidget {
  final int ptgId;
  final Function(DateTime) onSelecParam;
  BlocDatePicker({this.onSelecParam, this.ptgId});
  @override
  _BlocDatePickerState createState() => _BlocDatePickerState();
}

class _BlocDatePickerState extends State<BlocDatePicker> {
  CalendarController controller;
  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().add(Duration(hours: 1)).hour, minute: 0);
  DateTime _selectedDateTime = DateTime.now().toLocal();
  CalendarModel photographerDays;
  List<BookingBlocModel> listBookingByDate = List<BookingBlocModel>();
  TimeOfDay _startWorkingTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endWorkingTime = TimeOfDay(hour: 23, minute: 59);

  _checkOutOfWorkingDate(TimeOfDay timeOfDay) async {
    TimeOfDay newTime =
        TimeOfDay(hour: timeOfDay.hour + 1, minute: timeOfDay.minute);
    DateTime newDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, newTime.hour, newTime.minute);
    BlocProvider.of<WarningBloc>(context).add(WarningEventCheckOutOfWorkingTime(
        ptgId: widget.ptgId, time: DateFormat('HH:mm').format(newDateTime)));
  }

  _getTimeWarning(String dateTime) async {
    BlocProvider.of<WarningBloc>(context).add(
        WarningEventGetTimeWarning(dateTime: dateTime, ptgId: widget.ptgId));
  }

  _loadCalendar() async {
    BlocProvider.of<CalendarBloc>(context)
        .add(CalendarEventPhotographerDaysFetch(ptgId: widget.ptgId));
  }

  _loadBookingByDate(String selectedDay) async {
    BlocProvider.of<BookingBloc>(context).add(
        BookingEventGetBookingOnDate(ptgId: widget.ptgId, date: selectedDay));
  }

  _loadWorkingDateOfPtg() async {
    BlocProvider.of<WorkingDayBloc>(context)
        .add(WorkingDayEventFetch(ptgId: widget.ptgId));
  }

  _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  void getTime() {
    _selectedDateTime = new DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        _time.hour,
        _time.minute);
  }

  final Map<DateTime, List> _holidays = {};

  final Map<DateTime, List> _events = {};

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      getTime();
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    _loadBookingByDate(DateFormat('yyyy-MM-dd').format(day));
    _selectedDateTime = day;
  }

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
    _loadCalendar();
    _loadBookingByDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _loadWorkingDateOfPtg();
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  bool _predicate(DateTime day) {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    if ((day.isBefore(DateTime.now().toLocal()))) {
      return false;
    }
    for (var item in photographerDays.busyDays) {
      if (dateFormat
              .format(day.toLocal())
              .compareTo(dateFormat.format(DateTime.parse(item).toLocal())) ==
          0) {
        return false;
      }
    }
    return true;
  }

  Widget buildTableCalendar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: TableCalendar(
        onDaySelected: _onDaySelected,
        holidays: _holidays,
        events: _events,
        locale: 'vi_VN',
        initialSelectedDay: _selectedDateTime,
        calendarController: controller,
        startingDayOfWeek: StartingDayOfWeek.monday,
        initialCalendarFormat: CalendarFormat.month,
        formatAnimation: FormatAnimation.slide,
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
          ),
          leftChevronIcon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 15,
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black87,
            size: 15,
          ),
          leftChevronMargin: EdgeInsets.only(left: 40.0),
          rightChevronMargin: EdgeInsets.only(right: 40.0),
        ),
        enabledDayPredicate: _predicate,
        calendarStyle: CalendarStyle(
          selectedColor: Theme.of(context).accentColor,
          todayStyle: TextStyle().copyWith(color: Colors.black87),
          markersColor: Colors.pinkAccent,
          outsideDaysVisible: false,
          weekendStyle: TextStyle().copyWith(color: Colors.black87),
          todayColor: Colors.white,
          holidayStyle: TextStyle().copyWith(color: Colors.black87),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildEventList(List<BookingBlocModel> listBookings) {
    return listBookings.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Photographer đã được đặt vào lúc',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      wordSpacing: -1,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Column(
                  children: listBookings
                      .asMap()
                      .entries
                      .map((MapEntry mapEntry) => Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 6.0)
                                ]),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            child: ClipRRect(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  leading: Icon(Icons.event_busy_outlined,
                                      color: Theme.of(context).primaryColor),
                                  title: Text(
                                    'Thời gian:   ${DateFormat('hh:mm a').format(DateTime.parse(listBookings[mapEntry.key].startDate).toLocal())} - ${DateFormat('hh:mm a').format(DateTime.parse(listBookings[mapEntry.key].startDate).add(Duration(hours: (listBookings[mapEntry.key].timeAnticipate / 3600).round())).toLocal())} ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () => print(
                                      '${listBookings[mapEntry.key]} tapped!'),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          BlocListener<WorkingDayBloc, WorkingDayState>(
            listener: (context, state) {
              if (state is WorkingDayStateFetchSuccess) {
                final splitStringStartTime =
                    state.listWorkingDays[0].startTime.split(':');
                final splitStringEndTime =
                    state.listWorkingDays[0].endTime.split(':');
                _startWorkingTime = TimeOfDay(
                    hour: int.parse(splitStringStartTime[0]) - 1,
                    minute: int.parse(splitStringStartTime[1]));
                _endWorkingTime = TimeOfDay(
                    hour: int.parse(splitStringEndTime[0]) - 1,
                    minute: int.parse(splitStringEndTime[1]));
                setState(() {});
              }
            },
            child: SizedBox(),
          ),
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state is CalendarStatePhotographerDaysSuccess) {
                photographerDays = state.photographerDays;
                for (String day in state.photographerDays.bookedDays) {
                  _events[DateTime.parse(day).toLocal()] = [day];
                }
                for (String day in state.photographerDays.busyDays) {
                  _holidays[DateTime.parse(day).toLocal()] = [day];
                }
                return PlaneIndicator(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, top: 20.0),
                          child: Text(
                            'Chọn thời gian ',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        margin: const EdgeInsets.only(left: 15.0, right: 290.0),
                        height: 3.0,
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0)
                            ]),
                        child: buildTableCalendar(),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            'Giờ làm việc của Photographer',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              wordSpacing: -1,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0)
                              ]),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          child: ClipRRect(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                leading:
                                    Icon(Icons.event, color: Colors.green[300]),
                                title: Text(
                                  '${formatTimeOfDay(_startWorkingTime)} - ${formatTimeOfDay(_endWorkingTime)} ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      BlocConsumer<BookingBloc, BookingState>(
                        listener: (context, state) {
                          if (state is BookingStateFailure) {
                            String error =
                                state.error.replaceAll('Exception: ', '');

                            if (error.toUpperCase() == 'UNAUTHORIZED') {
                              _showUnauthorizedDialog();
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is BookingStateLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Loading(),
                            );
                          }

                          if (state is BookingStateFailure) {
                            return SizedBox();
                          }
                          if (state is BookingStateGetBookingByDateSuccess) {
                            final tempListBooking = List<BookingBlocModel>();
                            for (var booking in state.listBookings) {
                              if (booking.status.toUpperCase() == 'ONGOING') {
                                tempListBooking.add(booking);
                              }
                            }
                            listBookingByDate = tempListBooking;
                            return _buildEventList(tempListBooking);
                          }
                          return Text('');
                        },
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 45.0,
                                left: 30.0,
                              ),
                              child: Text(
                                'Chọn thời gian bắt đầu:',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.timer,
                              color: Theme.of(context).primaryColor,
                              size: 20.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: GestureDetector(
                                child: Text(
                                  '${_time.format(context)}',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    showPicker(
                                      context: context,
                                      value: _time,
                                      onChange: onTimeChanged,
                                      sunAsset:
                                          Image.asset('assets/images/sun.png'),
                                      moonAsset:
                                          Image.asset('assets/images/moon.png'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      BlocListener<WarningBloc, WarningState>(
                        listener: (context, state) {
                          if (state is WarningStateLoading) {
                            _showLoadingAlert();
                          }
                          if (state
                              is WarningStateCheckOutOfWorkingTimeSuccess) {
                            Navigator.pop(context);
                            if (!state.isOutOfWorkingTime) {
                              getTime();
                              _getTimeWarning(
                                  '${DateFormat("yyyy-MM-ddHH:mm").format(_selectedDateTime)}');
                            } else {
                              popUp(context, 'Chọn thời gian chụp',
                                  'Xin hãy chọn thời gian trong khoảng thời gian làm việc của Photographer.');
                            }
                          }
                          if (state is WarningStateGetTimeWarningSuccess) {
                            Navigator.pop(context);
                            if (state.notices.isNotEmpty) {
                              String locationWarning = '';
                              var timeAndName = [];

                              locationWarning = state.notices.first.toString();
                              timeAndName = locationWarning.split(',');

                              _showTimeWarning(
                                  'Lịch hẹn trước của photographer kết thúc vào lúc ${timeAndName[0]}. Bạn có muốn tiếp tục?');
                            } else {
                              getTime();
                              widget.onSelecParam(_selectedDateTime);
                              Navigator.pop(context,
                                  '${DateFormat('dd/MM/yyyy hh:mm a').format(_selectedDateTime)}');
                            }
                          }
                          if (state is WarningStateFailure) {
                            Navigator.pop(context);
                            String error =
                                state.error.replaceAll('Exception: ', '');

                            if (error.toUpperCase() == 'UNAUTHORIZED') {
                              _showUnauthorizedDialog();
                            }
                          }
                        },
                        child: RaisedButton(
                          onPressed: () {
                            getTime();
                            bool isAppropriateTime = true;

                            for (var booking in listBookingByDate) {
                              if (((_selectedDateTime.isAfter(
                                          DateTime.parse(booking.startDate)) &&
                                      _selectedDateTime.isBefore(
                                          DateTime.parse(booking.startDate).add(
                                              Duration(
                                                  hours: (booking.timeAnticipate /
                                                          3600)
                                                      .round()))))) ||
                                  _selectedDateTime.isAtSameMomentAs(
                                      DateTime.parse(booking.startDate)) ||
                                  _selectedDateTime.isAtSameMomentAs(
                                      DateTime.parse(booking.startDate).add(
                                          Duration(hours: (booking.timeAnticipate / 3600).round())))) {
                                popUp(context, 'Chọn thời gian',
                                    'Xin vui lòng không chọn trùng giờ với lịch hẹn hiện tại của Photographer');
                                isAppropriateTime = false;
                                return;
                              }
                            }

                            if (isAppropriateTime) {
                              if (_selectedDateTime.isAfter(
                                  DateTime.now().add(Duration(minutes: 30)))) {
                                _checkOutOfWorkingDate(_time);
                              } else {
                                popUp(context, 'Chọn thời gian',
                                    'Xin vui lòng chọn mốc thời gian sau 30 phút so với thời điểm hiện tại!');
                              }
                            }
                          },
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 100.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }

              if (state is CalendarStateLoading) {
                return DatePickerLoadingWidget();
              }
              return Center(
                  child: Text('Đã xảy ra lỗi trong lúc tải dữ liệu!'));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showTimeWarning(String notice) async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/alert.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Nhắc nhở',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                notice,
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                widget.onSelecParam(_selectedDateTime);
                Navigator.pop(context);
                Navigator.pop(context,
                    '${DateFormat("dd/MM/yyyy").format(_selectedDateTime)} ${_time.format(context)}');
              },
              onCancelButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: Theme.of(context).scaffoldBackgroundColor,
              buttonCancelText: Text(
                'Trở lại',
                style: TextStyle(color: Colors.black87),
              ),
            ));
  }

  Future<void> _showLoadingAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) {
          return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Material(
                type: MaterialType.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                child: Image.asset(
                  'assets/images/loading_2.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  // ignore: unused_element
  Future<void> _showBookingFailDialog() async {
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
                'Thất bại',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Đã có lỗi xảy ra trong lúc gửi yêu cầu.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
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
                _logOut();
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
