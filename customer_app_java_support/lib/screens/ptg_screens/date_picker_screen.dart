import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  Function(DateTime) onSelecParam;
  DatePicker({
    this.onSelecParam,
  });
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  CalendarController controller;
  TimeOfDay _time = TimeOfDay.now();
  DateTime _selectedDateTime = DateTime.now();

  final Map<DateTime, List> _holidays = {
    DateTime(2020, 10, 1): ['New Year\'s Day'],
    DateTime(2020, 10, 6): ['Epiphany'],
    DateTime(2020, 10, 15): ['Valentine\'s Day'],
    DateTime(2020, 10, 21): ['Easter Sunday'],
    DateTime(2020, 10, 22): ['Easter Monday'],
  };

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedDateTime = day;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  bool _predicate(DateTime day) {
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    print(dateFormat
        .format(day)
        .compareTo(dateFormat.format(DateTime.parse('2020-11-20 20:18:04Z'))));
    if ((day.isAfter(DateTime.now()))) {
      if (dateFormat.format(day).compareTo(
              dateFormat.format(DateTime.parse('2020-11-20 20:18:04Z'))) ==
          0) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            height: 390,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: TableCalendar(
                onDaySelected: _onDaySelected,
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
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 45.0,
                  left: 50.0,
                ),
                child: Text(
                  'Thời gian bắt đầu:',
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
                        sunAsset: Image.asset('assets/images/sun.png'),
                        moonAsset: Image.asset('assets/images/moon.png'),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              'Xác nhận',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
