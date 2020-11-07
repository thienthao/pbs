import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController controller;

  final Map<DateTime, List> _holidays = {
    DateTime(2020, 10, 1): ['New Year\'s Day'],
    DateTime(2020, 10, 6): ['Epiphany'],
    DateTime(2020, 10, 15): ['Valentine\'s Day'],
    DateTime(2020, 10, 21): ['Easter Sunday'],
    DateTime(2020, 10, 22): ['Easter Monday'],
  };

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 4.0)
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: TableCalendar(
              holidays: _holidays,
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
              calendarStyle: CalendarStyle(
                selectedColor: Colors.white,
                selectedStyle: TextStyle().copyWith(color: Colors.black87),
                todayColor: Colors.white,
                todayStyle: TextStyle().copyWith(color: Colors.black87),
                markersColor: Colors.pinkAccent,
                outsideDaysVisible: false,
                weekendStyle: TextStyle().copyWith(color: Colors.black87),
                holidayStyle: TextStyle().copyWith(
                  color: Colors.black87,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle().copyWith(color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
