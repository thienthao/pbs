import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/calendar_model.dart';
import 'package:customer_app_java_support/plane_indicator.dart';
import 'package:customer_app_java_support/shared/loading.dart';
import 'package:customer_app_java_support/shared/loading_line.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BlocDatePicker extends StatefulWidget {
  final int ptgId;
  final Function(DateTime) onSelecParam;
  BlocDatePicker({
    this.onSelecParam,
    this.ptgId,
  });
  @override
  _BlocDatePickerState createState() => _BlocDatePickerState();
}

class _BlocDatePickerState extends State<BlocDatePicker> {
  CalendarController controller;
  TimeOfDay _time = TimeOfDay.now();
  DateTime _selectedDateTime = DateTime.now().toLocal().add(Duration(days: 1));
  CalendarModel photographerDays;
  // List _selectedEvents;

  _loadCalendar() async {
    BlocProvider.of<CalendarBloc>(context)
        .add(CalendarEventPhotographerDaysFetch(ptgId: widget.ptgId));
  }

  _loadBookingByDate(String selectedDay) async {
    BlocProvider.of<BookingBloc>(context).add(
        BookingEventGetBookingOnDate(ptgId: widget.ptgId, date: selectedDay));
  }

  final Map<DateTime, List> _holidays = {};

  final Map<DateTime, List> _events = {};

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print(DateFormat('yyyy-MM-dd').format(day));
    _loadBookingByDate(DateFormat('yyyy-MM-dd').format(day));
    _selectedDateTime = day;
  }

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
    _loadCalendar();
    _loadBookingByDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  bool _predicate(DateTime day) {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    if ((day.isBefore(DateTime.now().toLocal()))) {
      return false;
    }
    for (var item in photographerDays.busyDays) {
      if (dateFormat
              .format(day)
              .compareTo(dateFormat.format(DateTime.parse(item))) ==
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
          holidayStyle: TextStyle().copyWith(
            color: Colors.black87,
            decoration: TextDecoration.lineThrough,
          ),
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
                                    'Slot ${mapEntry.key + 1}:   ${DateFormat('HH:mm a').format(DateTime.parse(listBookings[mapEntry.key].startDate).toLocal())} - ${DateFormat('HH:mm a').format(DateTime.parse(listBookings[mapEntry.key].startDate).add(Duration(hours: 6)).toLocal())} ',
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
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if (state is CalendarStatePhotographerDaysSuccess) {
                photographerDays = state.photographerDays;
                for (String day in state.photographerDays.bookedDays) {
                  _events[DateTime.parse(day)] = [day];
                }
                for (String day in state.photographerDays.busyDays) {
                  _holidays[DateTime.parse(day)] = [day];
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
                      BlocBuilder<BookingBloc, BookingState>(
                        builder: (context, state) {
                          if (state is BookingStateLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Loading(),
                            );
                          }

                          if (state is BookingStateFailure) {
                            return Text('fail!!');
                          }
                          if (state is BookingStateGetBookingByDateSuccess) {
                            return _buildEventList(state.listBookings);
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
                      RaisedButton(
                        onPressed: () {
                          widget.onSelecParam(_selectedDateTime);
                          Navigator.pop(context,
                              '${DateFormat("dd/MM/yyyy").format(_selectedDateTime)} ${_time.format(context)}');
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
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }

              if (state is CalendarStateLoading) {
                return Container(child: Center(child: LoadingLine()));
              }
              return Text('Nothing');
            },
          ),
        ],
      ),
    );
  }
}
