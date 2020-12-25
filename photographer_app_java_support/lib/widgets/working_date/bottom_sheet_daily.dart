import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/working_date_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/shared/pop_up.dart';

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
      _days[sun],
      _days[mon],
      _days[tue],
      _days[wed],
      _days[thur],
      _days[fri],
      _days[sat],
    ];
    _newListWorkingDays.clear();
    for (var i = 0; i < 7; i++) {
      _newListWorkingDays.add(WorkingDayBlocModel(
          day: i + 1,
          workingDay: listIsWorkingDays[i],
          startTime: DateFormat("yyyy-MM-dd'T'").format(DateTime.now()) +
              _timeStart.format(context) +
              ':00',
          endTime: DateFormat("yyyy-MM-dd'T'").format(DateTime.now()) +
              _timeEnd.format(context) +
              ':00'));
    }
    setState(() {
      widget.onListWorkingDaysUpdate(_newListWorkingDays);
    });
    BlocProvider.of<WorkingDayBloc>(context).add(WorkingDayEventUpdate(
        ptgId: globalPtgId, listWorkingDays: _newListWorkingDays));
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
      if (item.day == 2) {
        days[mon] = item.workingDay;
      } else if (item.day == 3) {
        days[tue] = item.workingDay;
      } else if (item.day == 4) {
        days[wed] = item.workingDay;
      } else if (item.day == 5) {
        days[thur] = item.workingDay;
      } else if (item.day == 6) {
        days[fri] = item.workingDay;
      } else if (item.day == 7) {
        days[sat] = item.workingDay;
      } else if (item.day == 1) {
        days[sun] = item.workingDay;
      }
    }
    final splitStringStartTime = widget.listWorkingDays[0].startTime.split(':');
    final splitStringEndTime = widget.listWorkingDays[0].endTime.split(':');
    _timeStart = TimeOfDay(
        hour: int.parse(splitStringStartTime[0]) - 1,
        minute: int.parse(splitStringStartTime[1]));
    _timeEnd = TimeOfDay(
        hour: int.parse(splitStringEndTime[0]) -1,
        minute: int.parse(splitStringEndTime[1]));
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
        BlocListener<WorkingDayBloc, WorkingDayState>(
          listener: (context, state) {
            if (state is WorkingDayStateUpdateSuccess) {
              Navigator.pop(context);
              _showSuccessAlert();
              popUp(context, 'Cập nhật các ngày làm việc hằng tuần',
                  'Đã cập nhật thành công các ngày làm việc hằng tuần');
            }
            if (state is WorkingDayStateLoading) {
              _showLoadingAlert();
            }
            if (state is WorkingDayStateFailure) {
              Navigator.pop(context);
              _showFailDialog();
              popUp(context, 'Cập nhật các ngày làm việc hằng tuần',
                  'Cập nhật thất bại');
            }
          },
          child: SizedBox(),
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

  Future<void> _showSuccessAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/done_booking.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Hoàn thành',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Cập nhật thành công!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
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

  Future<void> _showFailDialog() async {
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
}
