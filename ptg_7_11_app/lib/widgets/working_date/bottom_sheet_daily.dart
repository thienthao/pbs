import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

class BottomSheetDaily extends StatefulWidget {
  @override
  _BottomSheetDailyState createState() => _BottomSheetDailyState();
}

class _BottomSheetDailyState extends State<BottomSheetDaily> {
  TimeOfDay _timeStart = TimeOfDay.now();
  TimeOfDay _timeEnd = TimeOfDay.now();

  void onTimeStart(TimeOfDay newTime) {
    setState(() {
      _timeStart = newTime;
    });
  }
  void onTimeEnd(TimeOfDay newTime) {
    setState(() {
      _timeEnd = newTime;
    });
  }

  static String sun = "Chủ nhật";
  static String mon = "Thứ hai";
  static String tue = "Thứ ba";
  static String wed = "Thứ tư";
  static String thur = "Thứ năm";
  static String fri = "Thứ sáu";
  static String sat = "Thứ bảy";

  Map<String, bool> days = {
    sun: false,
    mon: false,
    tue: false,
    wed: false,
    thur: false,
    fri: false,
    sat: false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 20.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10.0),
              Text(
                'Chọn giờ làm việc',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    'Từ:',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: GestureDetector(
                      child: Text(
                        '${_timeStart.format(context)}',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _timeStart,
                            onChange: onTimeStart,
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
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    'Đến:',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: GestureDetector(
                      child: Text(
                        '${_timeEnd.format(context)}',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          showPicker(
                            context: context,
                            value: _timeEnd,
                            onChange: onTimeEnd,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10.0),
              Text(
                'Chọn ngày làm việc',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: [
              checkbox(mon, days[mon]),
              SizedBox(width: 53.0),
              checkbox(fri, days[fri]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: [
              checkbox(tue, days[tue]),
              SizedBox(width: 55.0),
              checkbox(sat, days[sat]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: [
              checkbox(wed, days[wed]),
              SizedBox(width: 59.0),
              checkbox(sun, days[sun]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            children: [
              checkbox(thur, days[thur]),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 110.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              'Xác nhận',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: (value) => setState(() => days[title] = value),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}