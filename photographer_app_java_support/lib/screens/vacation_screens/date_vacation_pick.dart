import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class VacationPicker extends StatefulWidget {
  @override
  _VacationPickerState createState() => _VacationPickerState();
}

class _VacationPickerState extends State<VacationPicker> {
  CalendarController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 110.0),
                child: Text(
                  'Chọn thời gian nghỉ',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
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
              Padding(
                padding: EdgeInsets.only(left: 30.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày nghỉ:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Ngày nghỉ của tôi...',
                        hintStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 350,
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
                      selectedColor: Theme.of(context).accentColor,
                      todayStyle: TextStyle().copyWith(color: Colors.black87),
                      markersColor: Colors.pinkAccent,
                      outsideDaysVisible: false,
                      weekendStyle: TextStyle().copyWith(color: Colors.black87),
                      todayColor: Colors.white,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle().copyWith(color: Colors.black87),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                padding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
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
        ],
      ),
    );
  }
}
