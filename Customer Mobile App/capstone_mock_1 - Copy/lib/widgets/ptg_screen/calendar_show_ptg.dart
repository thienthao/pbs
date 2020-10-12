import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 140),
          child: Text(
            'Thời gian biểu',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          height: 350,
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
                todayColor: Colors.redAccent[200],
                outsideDaysVisible: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
