import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/busy_day_blocs/busy_days.dart';
import 'package:photographer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';
import 'package:photographer_app_java_support/models/working_date_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/calendar_repository.dart';
import 'package:photographer_app_java_support/screens/vacation_screens/date_vacation_pick.dart';
import 'package:photographer_app_java_support/screens/vacation_screens/date_vacation_pick_edit.dart';
import 'package:photographer_app_java_support/widgets/working_date/bottom_sheet_daily.dart';

class ListVacation extends StatefulWidget {
  @override
  _ListVacationState createState() => _ListVacationState();
}

class _ListVacationState extends State<ListVacation> {
  List<WorkingDayBlocModel> _listWorkingDays;
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadBusyDays();
  }

  _loadBusyDays() async {
    BlocProvider.of<BusyDayBloc>(context).add(BusyDayEventFetch(ptgId: 168));
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {});
  }

  FutureOr onGoBack(dynamic value) {
    for (var item in _listWorkingDays) {
      print('${item.day} + ${item.workingDay}');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Lịch làm việc của tôi',
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: -2,
          ),
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  if (_listWorkingDays != null) {
                    onPressedButton();
                  } else {
                    print('Has not loaded yet!');
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 130.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: FlatButton.icon(
                        label: Text(
                          'Hằng tuần',
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: null,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => BusyDayBloc(
                            calendarRepository: _calendarRepository),
                        child: VacationPicker(),
                      );
                    }),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 130.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<BusyDayBloc, BusyDayState>(
            builder: (context, state) {
              if (state is BusyDayStateFetchSuccess) {
                return RefreshIndicator(
                  onRefresh: () {
                    _loadBusyDays();
                    return _completer.future;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.listBusyDays.length,
                    itemBuilder: (BuildContext context, int index) {
                      BusyDayBlocModel busyDay = state.listBusyDays[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return BlocProvider(
                                create: (context) => BusyDayBloc(
                                    calendarRepository: _calendarRepository),
                                child: VacationPickerEdit(
                                  busyDayBlocModel: busyDay,
                                ),
                              );
                            }),
                          );
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.3,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 5,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      busyDay.title,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.timer,
                                          size: 15,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        child: Text(
                                          'Thời gian:',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  busyDay.startDate)),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          secondaryActions: [
                            IconSlideAction(
                              caption: "Xóa",
                              color: Theme.of(context).primaryColor,
                              icon: Icons.close,
                              onTap: () {},
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              if (state is BusyDayStateLoading) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Container();
            },
          ),
          BlocBuilder<WorkingDayBloc, WorkingDayState>(
            builder: (context, state) {
              if (state is WorkingDayStateFetchSuccess) {
                _listWorkingDays = state.listWorkingDays;

              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              color: Color(0xFF737373),
              child: Container(
                child: BlocProvider(
                  create: (context) =>
                      WorkingDayBloc(calendarRepository: _calendarRepository),
                  child: BottomSheetDaily(
                    onListWorkingDaysUpdate:
                        (List<WorkingDayBlocModel> updatedList) {
                      setState(() {
                        _listWorkingDays = updatedList;
                      });
                      print(
                          '${_listWorkingDays[0].day} : ${_listWorkingDays[0].workingDay} ');
                    },
                    listWorkingDays: _listWorkingDays,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
