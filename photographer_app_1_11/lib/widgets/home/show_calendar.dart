import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarShow extends StatefulWidget {
  @override
  _CalendarShowState createState() => _CalendarShowState();
}

class _CalendarShowState extends State<CalendarShow> {
  CalendarController controller;
  Map<DateTime, List> _events;
  TimeOfDay _time = TimeOfDay.now();
  DateTime _selectedDateTime = DateTime.now();

  final Map<DateTime, List> _holidays = {
    DateTime(2020, 10, 1): ['New Year\'s Day'],
    DateTime(2020, 10, 6): ['Epiphany'],
    DateTime(2020, 10, 19): ['Valentine\'s Day'],
    DateTime(2020, 10, 23): ['Easter Sunday'],
    DateTime(2020, 10, 24): ['Easter Monday'],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _selectedDay = DateTime.now();
    controller = CalendarController();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6'],
      _selectedDay: ['Event A7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
      ],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14'],
    };
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected $day');
    final finalDate = day.year.toString() +
        "-" +
        day.month.toString() +
        "-" +
        day.day.toString();
    print('$finalDate');
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
