import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:table_calendar/table_calendar.dart';

class VacationPickerEdit extends StatefulWidget {
  final BusyDayBlocModel busyDayBlocModel;

  const VacationPickerEdit({this.busyDayBlocModel});
  @override
  _VacationPickerEditState createState() => _VacationPickerEditState();
}

class _VacationPickerEditState extends State<VacationPickerEdit> {
  CalendarController controller;
  TextEditingController titleTxtController = TextEditingController();
  TextEditingController descriptionTxtController = TextEditingController();
  DateTime daySelected = DateTime.now();

  void _onDaySelected(DateTime day, List events, List holidays) {
    daySelected = day;
  }

  _updateBusyDay() async {
    BlocProvider.of<BusyDayBloc>(context).add(BusyDayEventUpdate(
        ptgId: 168,
        busyDayBlocModel: BusyDayBlocModel(
          id: widget.busyDayBlocModel.id,
          title: titleTxtController.text,
          description: descriptionTxtController.text,
          startDate:
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(daySelected),
        )));
  }

  _deleteBusyDay() async {
    BlocProvider.of<BusyDayBloc>(context).add(
        BusyDayEventDelete(ptgId: 168, busyDayId: widget.busyDayBlocModel.id));
  }

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
    titleTxtController.text = widget.busyDayBlocModel.title;
    descriptionTxtController.text = widget.busyDayBlocModel.description;
    daySelected = DateTime.parse(widget.busyDayBlocModel.startDate);
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
                      'Tiêu đề:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
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
                    TextField(
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
                    calendarController: controller,
                    initialSelectedDay: daySelected,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    minWidth: 150.0,
                    height: 60.0,
                    color: Colors.white,
                    onPressed: () {
                      _deleteBusyDay();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Xoá',
                        style: TextStyle(fontSize: 21.0, color: Colors.black87),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  ButtonTheme(
                    buttonColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minWidth: 180.0,
                    height: 60.0,
                    child: RaisedButton(
                      onPressed: () {
                        _updateBusyDay();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Cập nhật',
                          style: TextStyle(fontSize: 21.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<BusyDayBloc, BusyDayState>(
                builder: (context, state) {
                  if (state is BusyDayStateCreatedSuccess) {
                    return Text('Created Success!!');
                  }
                  if (state is BusyDayStateUpdatedSuccess) {
                    return Text('Updated Success!!');
                  }
                  if (state is BusyDayStateDeletedSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                  }
                  // if (state is BusyDayStateLoading) {
                  //   return Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 10),
                  //     child: LinearProgressIndicator(),
                  //   );
                  // }

                  return Container();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
