import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/booking_many_screens/booking_many_detail.dart';
import 'package:customer_app_java_support/screens/booking_many_screens/booking_many_detail_edit.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReturnTypeModel {
  int id;
  String name;

  ReturnTypeModel(this.id, this.name);

  static List<ReturnTypeModel> getReturnTypes() {
    return <ReturnTypeModel>[
      ReturnTypeModel(2, 'Gặp mặt tận nơi'),
      ReturnTypeModel(1, 'Thông qua ứng dụng'),
    ];
  }
}

class BookingManyDayEdit extends StatefulWidget {
  final PackageBlocModel selectedPackage;
  final BookingBlocModel bookingBlocModel;
  final Photographer photographer;
  final Function(bool) isEdited;

  const BookingManyDayEdit(
      {this.selectedPackage,
      this.photographer,
      this.bookingBlocModel,
      this.isEdited});

  @override
  _BookingManyDayEditState createState() => _BookingManyDayEditState();
}

class _BookingManyDayEditState extends State<BookingManyDayEdit> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  WarningRepository _warningRepository =
      WarningRepository(httpClient: http.Client());
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  String timeReturnResult = 'Hãy chọn thời gian nhận';
  String endDate = '';
  String editDeadLine = '';
  String startDate = '';
  DateTime lastDay = DateTime.now();
  bool notDuplicate = true;
  List<PackageBlocModel> listPackages = List<PackageBlocModel>();

  List<ReturnTypeModel> returnedTypes = ReturnTypeModel.getReturnTypes();
  List<DropdownMenuItem<ReturnTypeModel>> dropDownMenuItems;
  ReturnTypeModel selectedType;

  List<DropdownMenuItem<PackageBlocModel>> packageDropDownMenuItems;
  PackageBlocModel selectedPackage;

  List<TimeAndLocationBlocModel> listTimeAndLocation =
      List<TimeAndLocationBlocModel>();

  List<DropdownMenuItem<ReturnTypeModel>> buildDropdownMenuItems(
      List returnedTypes) {
    List<DropdownMenuItem<ReturnTypeModel>> items = List();
    for (ReturnTypeModel type in returnedTypes) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(
            type.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<PackageBlocModel>> buildPackageDropdownMenuItems(
      List packages) {
    List<DropdownMenuItem<PackageBlocModel>> items = List();
    for (PackageBlocModel package in packages) {
      items.add(
        DropdownMenuItem(
          value: package,
          child: Text(package.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(ReturnTypeModel newSelectedType) {
    setState(() {
      selectedType = newSelectedType;
    });
  }

  onChangePackageDropdownItem(PackageBlocModel newSelectedPackage) {
    setState(() {
      selectedPackage = newSelectedPackage;
    });
  }

  _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  _editBooking() async {
    if (_validateBooking()) {
      if (selectedPackage != null) {
        List<TimeAndLocationBlocModel> timeAndLocations = listTimeAndLocation;

        BookingBlocModel booking = BookingBlocModel(
            id: widget.bookingBlocModel.id,
            serviceName: selectedPackage.name,
            price: selectedPackage.price,
            editDeadLine: DateFormat("yyyy-MM-dd'T'HH:mm")
                .format(DateTime.parse(editDeadLine)),
            photographer: Photographer(id: widget.photographer.id),
            package: selectedPackage,
            returningType: selectedType.id,
            listTimeAndLocations: timeAndLocations);

        BlocProvider.of<BookingBloc>(context)
            .add(BookingEventEdit(booking: booking, cusId: globalCusId));
      }
    }
  }

  bool _validateBooking() {
    print(lastDay);
    if (listTimeAndLocation == null) {
      popUp(context, 'Địa điểm và thời gian chụp',
          'Xin hãy chọn thời gian chụp và địa điểm');
      return false;
    } else if (listTimeAndLocation.isEmpty) {
      popUp(context, 'Địa điểm và thời gian chụp',
          'Xin hãy chọn thời gian chụp và địa điểm');
      return false;
    } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
      popUp(context, 'Nhập thời gian nhận', 'Xin hãy chọn thời gian nhận');
      return false;
    } else if (!lastDay.isBefore(DateTime.parse(editDeadLine))) {
      popUp(context, 'Thời gian nhận',
          'Thời gian nhận ảnh phải sau ngày chụp cuối ít nhất 1 ngày');
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    dropDownMenuItems = buildDropdownMenuItems(returnedTypes);
    print(widget.bookingBlocModel.returningType);
    selectedType =
        dropDownMenuItems[widget.bookingBlocModel.returningType - 1].value;
    listTimeAndLocation = widget.bookingBlocModel.listTimeAndLocations;
    timeReturnResult = DateFormat('dd/MM/yyy hh:mm a')
        .format(DateTime.parse(widget.bookingBlocModel.editDeadLine).toLocal());
    editDeadLine = widget.bookingBlocModel.editDeadLine;

    for (var item in listTimeAndLocation) {
      if (lastDay.isBefore(DateTime.parse(item.end))) {
        lastDay = DateTime.parse(item.end);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Đặt lịch với ${widget.photographer.fullname}',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.grey[50],
        floatingActionButton: FloatingActionButton(
          onPressed: _editBooking,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingStateEditedSuccess) {
              Navigator.pop(context);
              widget.isEdited(true);
              _showSuccessAlert();
              popUp(context, 'Cập nhật cuộc hẹn', 'Cập nhật thành công!!');
            }

            if (state is BookingStateLoading) {
              _showLoadingAlert();
            }
            if (state is BookingStateFailure) {
              Navigator.pop(context);
              String error = state.error.replaceAll('Exception: ', '');
              if (error.toUpperCase() == 'UNAUTHORIZED') {
                _showUnauthorizedDialog();
              } else {
                popUp(context, 'Cập nhật cuộc hẹn',
                    'Cập nhật không thành công!!');
              }
            }
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 30, bottom: 10),
                child: Text(
                  'Người chụp ảnh',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    wordSpacing: -1,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 65.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.photographer.avatar),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      widget.photographer.fullname,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                child: Text(
                  'Thông tin gói dịch vụ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    wordSpacing: -1,
                    color: Colors.black,
                  ),
                ),
              ),
              BlocListener<PackageBloc, PackageState>(
                listener: (context, state) {
                  if (state is PackageStateSuccess) {
                    for (PackageBlocModel package in state.packages) {
                      if (package.supportMultiDays) {
                        listPackages.add(package);
                      }
                    }

                    for (var item in state.packages) {
                      if (item.id == widget.selectedPackage.id) {
                        selectedPackage = item;
                      }
                    }
                    packageDropDownMenuItems =
                        buildPackageDropdownMenuItems(listPackages);

                    setState(() {});
                  }
                  if (state is PackageStateLoading) {
                    return CircularProgressIndicator();
                  }

                  if (state is PackageStateFailure) {
                    String error = state.error.replaceAll('Exception: ', '');
                    if (error.toUpperCase() == 'UNAUTHORIZED') {
                      _showUnauthorizedDialog();
                    }
                  }
                },
                child: SizedBox(),
              ),
              //////////gói dịch vụ
              _buildPackage(),
              //////////gói dịch vụ
              ///
              ///

              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông tin ngày chụp',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        wordSpacing: -1,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => WarningBloc(
                                        warningRepository: _warningRepository),
                                  ),
                                ],
                                child: BookingManyDetail(
                                  timeAnticipate:
                                      selectedPackage.timeAnticipate,
                                  ptgId: widget.photographer.id,
                                  onUpdateList:
                                      (TimeAndLocationBlocModel model) {
                                    for (var item in listTimeAndLocation) {
                                      if (DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(model.start)) ==
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(item.start))) {
                                        notDuplicate = false;
                                        return;
                                      }
                                    }
                                    if (notDuplicate) {
                                      listTimeAndLocation.add(model);
                                      if (DateTime.parse(model.start)
                                              .add(Duration(days: 1))
                                              .isAfter(lastDay) ||
                                          DateTime.parse(model.start)
                                              .add(Duration(days: 1))
                                              .isAtSameMomentAs(lastDay)) {
                                        lastDay = DateTime.parse(model.start);
                                      }
                                    }

                                    setState(() {});
                                  },
                                ));
                          }),
                        ).then((value) {
                          if (!notDuplicate) {
                            popUp(context, 'Chọn ngày chụp',
                                'Bạn không được chọn trùng ngày với nhau!');
                            notDuplicate = true;
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Thêm ngày',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            wordSpacing: -1,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: listTimeAndLocation
                    .asMap()
                    .entries
                    .map((MapEntry mapEntry) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 1000),
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation,
                                  Widget child) {
                                animation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.fastLinearToSlowEaseIn);
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation) {
                                return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => WarningBloc(
                                            warningRepository:
                                                _warningRepository),
                                      ),
                                    ],
                                    child: BookingManyDetailEdit(
                                      timeAnticipate:
                                          selectedPackage.timeAnticipate,
                                      ptgId: widget.photographer.id,
                                      model: listTimeAndLocation[mapEntry.key],
                                      onUpdateList:
                                          (TimeAndLocationBlocModel model) {
                                        if (listTimeAndLocation.length > 1) {
                                          for (var item
                                              in listTimeAndLocation) {
                                            if (item !=
                                                listTimeAndLocation[
                                                    mapEntry.key]) {
                                              if (DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(
                                                          model.start)) ==
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(
                                                          item.start))) {
                                                notDuplicate = false;
                                                return;
                                              }
                                            }
                                          }
                                        }

                                        if (notDuplicate) {
                                          listTimeAndLocation[mapEntry.key] =
                                              model;
                                          if (DateTime.parse(model.start)
                                                  .add(Duration(days: 1))
                                                  .isAfter(lastDay) ||
                                              DateTime.parse(model.start)
                                                  .add(Duration(days: 1))
                                                  .isAtSameMomentAs(lastDay)) {
                                            lastDay =
                                                DateTime.parse(model.start);
                                          }
                                        }

                                        setState(() {});
                                      },
                                    ));
                              })).then((value) {
                        if (!notDuplicate) {
                          popUp(context, 'Chọn ngày chụp',
                              'Bạn không được chọn trùng ngày với nhau!');
                          notDuplicate = true;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(-1.0, 2.0),
                              blurRadius: 6.0)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 100.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.0, left: 7.0),
                              child: Text(
                                'Ngày ${mapEntry.key + 1}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Theme.of(context).primaryColor,
                                      size: 15.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(
                                        listTimeAndLocation[mapEntry.key]
                                            .formattedAddress,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: Theme.of(context).primaryColor,
                                      size: 15.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      DateFormat("dd/MM/yyyy hh:mm a").format(
                                          DateTime.parse(listTimeAndLocation[
                                                      mapEntry.key]
                                                  .start)
                                              .toLocal()),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  onTap: () {
                                    int tempKey = mapEntry.key;
                                    TimeAndLocationBlocModel tempModel =
                                        listTimeAndLocation[mapEntry.key];
                                    listTimeAndLocation.removeAt(mapEntry.key);
                                    DateTime tempLatestDate = DateTime.parse(
                                        listTimeAndLocation[0].start);
                                    for (var item in listTimeAndLocation) {
                                      if (DateTime.parse(item.start)
                                              .isAfter(tempLatestDate) ||
                                          DateTime.parse(item.start)
                                              .isAtSameMomentAs(
                                                  tempLatestDate)) {
                                        tempLatestDate =
                                            DateTime.parse(item.start);
                                      }
                                    }
                                    lastDay = tempLatestDate;
                                    Flushbar(
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      flushbarStyle: FlushbarStyle.GROUNDED,
                                      backgroundColor: Colors.black54,
                                      reverseAnimationCurve: Curves.decelerate,
                                      forwardAnimationCurve: Curves.elasticOut,
                                      isDismissible: true,
                                      onStatusChanged: (v) {
                                        print(v);
                                      },
                                      duration: Duration(seconds: 10),
                                      titleText: Text(
                                        "Xóa ngày chụp",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontFamily: "Quicksand"),
                                      ),
                                      mainButton: FlatButton(
                                        color: Colors.black12,
                                        onPressed: () {
                                          listTimeAndLocation.insert(
                                              tempKey, tempModel);
                                          for (var item
                                              in listTimeAndLocation) {
                                            if (DateTime.parse(item.start)
                                                    .isAfter(tempLatestDate) ||
                                                DateTime.parse(item.start)
                                                    .isAtSameMomentAs(
                                                        tempLatestDate)) {
                                              tempLatestDate =
                                                  DateTime.parse(item.start);
                                            }
                                          }
                                          lastDay = tempLatestDate;
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text('Hoàn tác',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                      ),
                                      messageText: Text(
                                        "Bạn đã xóa 1 ngày chụp",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontFamily: "Quicksand"),
                                      ),
                                    ).show(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('Xóa ngày này',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              ///Thời gian nhận ảnh
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 5.0),
                child: Text(
                  'Thời gian nhận ảnh',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    wordSpacing: -1,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    final pageResult = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => CalendarBloc(
                                calendarRepository: _calendarRepository),
                          ),
                          BlocProvider(
                            create: (context) => BookingBloc(
                                bookingRepository: _bookingRepository),
                          )
                        ],
                        child: DatePicker(
                          lastDay: lastDay,
                          onSelecParam: (DateTime result) {
                            editDeadLine = result.toString();
                          },
                        ),
                      );
                    }));
                    setState(() {
                      if (pageResult != null) {
                        timeReturnResult = pageResult;
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeReturnResult,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 30,
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///Thời gian nhận ảnh

              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 5.0),
                child: Text(
                  'Phương thức nhận ảnh',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    wordSpacing: -1,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      value: selectedType,
                      items: dropDownMenuItems,
                      onChanged: onChangeDropdownItem,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.pink,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ));
  }

  Widget _buildPackage() {
    return selectedPackage != null
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.99,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      value: selectedPackage,
                      items: packageDropDownMenuItems,
                      onChanged: onChangePackageDropdownItem,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.pink,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontSize: 14.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Tên gói:  ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: selectedPackage.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Bao gồm các dịch vụ:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Column(
                          children: selectedPackage.serviceDtos
                              .asMap()
                              .entries
                              .map((MapEntry mapEntry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: Color(0xFFF77474),
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      selectedPackage
                                          .serviceDtos[mapEntry.key].name,
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        Divider(
                          height: 40.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${oCcy.format(selectedPackage.price)} đồng',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          )
        : SizedBox();
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
                'Thành Công',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Đã cập nhật thành công yêu cầu của bạn.',
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
                    borderRadius: BorderRadius.circular(10)),
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

  // ignore: unused_element
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

  Future<void> _showUnauthorizedDialog() async {
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
                'Thông báo',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Tài khoản không có quyền truy cập nội dung này!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                _logOut();
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
