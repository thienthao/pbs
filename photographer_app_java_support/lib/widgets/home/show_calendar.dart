import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/models/calendar_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarShow extends StatefulWidget {
  final CalendarModel photographerDays;
  final Function(String) onSelectedDate;
  CalendarShow({
    this.onSelectedDate,
    this.photographerDays,
  });
  @override
  _CalendarShowState createState() => _CalendarShowState();
}

class _CalendarShowState extends State<CalendarShow> {
  CalendarController controller;

  final Map<DateTime, List> _holidays = {};

  final Map<DateTime, List> _events = {};

  TimeOfDay _time = TimeOfDay.now();
  DateTime _selectedDateTime = DateTime.now();

  String getFormatDate(DateTime day) {
    return DateFormat('yyyy-MM-dd').format(day);
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    widget.onSelectedDate(getFormatDate(_selectedDay));

    controller = CalendarController();

    for (String day in widget.photographerDays.bookedDays) {
      if(day != 'null') {
        _events[DateTime.parse(day)] = [day];
      }

    }
    for (String day in widget.photographerDays.busyDays) {
      if (day != 'null') {
        _holidays[DateTime.parse(day)] = [day];
      }

    }
  }

  void onTimeChanged(TimeOfDay newTime) {

    setState(() {
      _time = newTime;
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    // print('CALLBACK: _onDaySelected $day');

    widget.onSelectedDate(getFormatDate(day));
    setState(() {
      _selectedDateTime = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      events: _events,
      holidays: _holidays,
      onDaySelected: _onDaySelected,
      locale: 'vi_VN',
      calendarController: controller,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
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
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).accentColor,
        todayStyle: TextStyle().copyWith(color: Colors.black),
        todayColor: Colors.white,
        markersColor: Colors.pinkAccent,
        weekendStyle: TextStyle().copyWith(color: Colors.black),
        outsideDaysVisible: false,
        holidayStyle: TextStyle().copyWith(color: Colors.black),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.black),
      ),
    );
  }
}
