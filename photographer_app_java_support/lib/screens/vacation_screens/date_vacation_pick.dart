import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:status_alert/status_alert.dart';
import 'package:table_calendar/table_calendar.dart';

class VacationPicker extends StatefulWidget {
  @override
  _VacationPickerState createState() => _VacationPickerState();
}

class _VacationPickerState extends State<VacationPicker> {
  CalendarController controller;
  TextEditingController titleTxtController = TextEditingController();
  TextEditingController descriptionTxtController = TextEditingController();
  DateTime daySelected = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  void _onDaySelected(DateTime day, List events, List holidays) {
    daySelected = day;
  }

  _createBusyDay() async {
    BlocProvider.of<BusyDayBloc>(context).add(BusyDayEventCreate(
        ptgId: 168,
        busyDayBlocModel: BusyDayBlocModel(
          title: titleTxtController.text,
          description: descriptionTxtController.text,
          startDate:
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(daySelected),
        )));
  }

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  String checkTextFormFieldIsEmpty(value) {
    if (value.isEmpty) {
      return 'Bạn không thể bỏ trống trường này!';
    }
    return null;
  }

  bool _predicate(DateTime day) {
    if ((day.isAfter(DateTime.now()))) {
      return true;
    }
    return false;
  }

  void popNotice() {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 60),
      title: 'Đang cập nhật',
      configuration: IconConfiguration(
        icon: Icons.send_to_mobile,
      ),
    );
  }

  void removeNotice() {
    StatusAlert.hide();
  }

  void popUp(String title, String content) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.black87,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      isDismissible: false,
      duration: Duration(seconds: 5),
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
            fontFamily: "Quicksand"),
      ),
      messageText: Text(
        content,
        style: TextStyle(
            fontSize: 16.0, color: Colors.white, fontFamily: "Quicksand"),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Chọn thời gian nghỉ',
          style: TextStyle(
            fontSize: 25.0,
            letterSpacing: -2,
          ),
        ),
        elevation: 3.0,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiêu đề:',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        validator: checkTextFormFieldIsEmpty,
                        controller: titleTxtController,
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
                      Text(
                        'Mô tả:',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: descriptionTxtController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                          hintText: 'Mô tả...',
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
                  height: 380,
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
                      enabledDayPredicate: _predicate,
                      calendarController: controller,
                      onDaySelected: _onDaySelected,
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
                        weekendStyle:
                            TextStyle().copyWith(color: Colors.black87),
                        todayColor: Colors.white,
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle:
                            TextStyle().copyWith(color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _createBusyDay();
                    }
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
                BlocListener<BusyDayBloc, BusyDayState>(
                  listener: (context, state) {
                    if (state is BusyDayStateCreatedSuccess) {
                      removeNotice();
                      popUp('Tạo ngày nghỉ', 'Tạo ngày nghỉ thành công!');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                      });
                    }
                    if (state is BusyDayStateLoading) {
                      popNotice();
                    }

                    return Container();
                  },
                  child: SizedBox(height: 30.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
