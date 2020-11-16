import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:photographer_app_java_support/models/working_date_bloc_model.dart';

class BottomSheetDaily extends StatefulWidget {
  final List<WorkingDayBlocModel> listWorkingDays;
  final Function(List<WorkingDayBlocModel>) onListWorkingDaysUpdate;
  BottomSheetDaily({this.listWorkingDays, this.onListWorkingDaysUpdate});
  @override
  _BottomSheetDailyState createState() => _BottomSheetDailyState();
}

class _BottomSheetDailyState extends State<BottomSheetDaily> {
  TimeOfDay _timeStart = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _timeEnd = TimeOfDay(hour: 22, minute: 0);
  List<WorkingDayBlocModel> _newListWorkingDays = List<WorkingDayBlocModel>();
  updateWorkingDays(Map<String, bool> _days) async {
    List<bool> listIsWorkingDays = [
      _days[mon],
      _days[tue],
      _days[wed],
      _days[thur],
      _days[fri],
      _days[sat],
      _days[sun]
    ];
    _newListWorkingDays.clear();
    for (var i = 0; i < 7; i++) {
      _newListWorkingDays.add(
          WorkingDayBlocModel(day: i + 1, workingDay: listIsWorkingDays[i]));
    }
    setState(() {
      widget.onListWorkingDaysUpdate(_newListWorkingDays);
    });
    BlocProvider.of<WorkingDayBloc>(context).add(WorkingDayEventUpdate(
        ptgId: 168, listWorkingDays: _newListWorkingDays));
  }

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

  static String mon = "Thứ hai";
  static String tue = "Thứ ba";
  static String wed = "Thứ tư";
  static String thur = "Thứ năm";
  static String fri = "Thứ sáu";
  static String sat = "Thứ bảy";
  static String sun = "Chủ nhật";
  Map<String, bool> days = {
    mon: false,
    tue: false,
    wed: false,
    thur: false,
    fri: false,
    sat: false,
    sun: false,
  };

  @override
  void initState() {
    super.initState();
    for (var item in widget.listWorkingDays) {
      if (item.day == 1) {
        days[mon] = item.workingDay;
      } else if (item.day == 2) {
        days[tue] = item.workingDay;
      } else if (item.day == 3) {
        days[wed] = item.workingDay;
      } else if (item.day == 4) {
        days[thur] = item.workingDay;
      } else if (item.day == 5) {
        days[fri] = item.workingDay;
      } else if (item.day == 6) {
        days[sat] = item.workingDay;
      } else if (item.day == 7) {
        days[sun] = item.workingDay;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            sunAsset: Image.asset('assets/images/sun.png'),
                            moonAsset: Image.asset('assets/images/moon.png'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                            sunAsset: Image.asset('assets/images/sun.png'),
                            moonAsset: Image.asset('assets/images/moon.png'),
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
              updateWorkingDays(days);
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
        BlocBuilder<WorkingDayBloc, WorkingDayState>(
          builder: (context, state) {
            if (state is WorkingDayStateUpdateSuccess) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Update Success!!')),
              );
            }
            if (state is WorkingDayStateFailure) {
              return Center(child: Text('Update Fail'));
            }
            return SizedBox();
          },
        )
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
