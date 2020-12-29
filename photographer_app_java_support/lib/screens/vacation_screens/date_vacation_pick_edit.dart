import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:table_calendar/table_calendar.dart';

class VacationPickerEdit extends StatefulWidget {
  final BusyDayBlocModel busyDayBlocModel;
  final Function(bool) checkIfEdited;
  const VacationPickerEdit({this.busyDayBlocModel, this.checkIfEdited});
  @override
  _VacationPickerEditState createState() => _VacationPickerEditState();
}

class _VacationPickerEditState extends State<VacationPickerEdit> {
  CalendarController controller;
  TextEditingController titleTxtController = TextEditingController();
  TextEditingController descriptionTxtController = TextEditingController();
  DateTime daySelected = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  void _onDaySelected(DateTime day, List events, List holidays) {
    daySelected = day;
  }

  _updateBusyDay() async {
    BlocProvider.of<BusyDayBloc>(context).add(BusyDayEventUpdate(
        ptgId: globalPtgId,
        busyDayBlocModel: BusyDayBlocModel(
          id: widget.busyDayBlocModel.id,
          title: titleTxtController.text,
          description: descriptionTxtController.text,
          startDate: DateFormat("yyyy-MM-dd'T'HH:mm").format(daySelected),
        )));
  }

  _deleteBusyDay() async {
    BlocProvider.of<BusyDayBloc>(context).add(BusyDayEventDelete(
        ptgId: globalPtgId, busyDayId: widget.busyDayBlocModel.id));
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Cập nhật thời gian nghỉ',
          style: TextStyle(
            fontSize: 25.0,
            letterSpacing: -2,
          ),
        ),
        elevation: 3.0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 10),
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
                        'Tiêu đề: *',
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
                          style:
                              TextStyle(fontSize: 21.0, color: Colors.black87),
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
                          if (_formKey.currentState.validate()) {
                            _updateBusyDay();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Cập nhật',
                            style:
                                TextStyle(fontSize: 21.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocListener<BusyDayBloc, BusyDayState>(
                  listener: (context, state) {
                    if (state is BusyDayStateUpdatedSuccess) {
                      widget.checkIfEdited(true);
                      Navigator.pop(context);
                      _showSuccessAlert();
                    }
                    if (state is BusyDayStateDeletedSuccess) {
                      widget.checkIfEdited(true);
                      Navigator.pop(context);
                      _showDeleteSuccessAlert();
                    }
                    if (state is BusyDayStateLoading) {
                      _showLoadingAlert();
                    }
                    if (state is BusyDayStateFailure) {
                      Navigator.pop(context);
                      _showFailDialog();
                    }
                  },
                  child: SizedBox(height: 30.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<void> _showDeleteSuccessAlert() async {
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
                'Xóa ngày nghỉ thành công!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
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
                'Cập nhật ngày nghỉ thành công!!',
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
