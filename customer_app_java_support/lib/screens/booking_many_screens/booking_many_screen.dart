import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/screens/booking_many_screens/booking_many_detail.dart';
import 'package:customer_app_java_support/screens/booking_many_screens/booking_many_detail_edit.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';

class ReturnTypeModel {
  int id;
  String name;

  ReturnTypeModel(this.id, this.name);

  static List<ReturnTypeModel> getReturnTypes() {
    return <ReturnTypeModel>[
      ReturnTypeModel(1, 'Thông qua ứng dụng'),
      ReturnTypeModel(2, 'Gặp mặt tận nơi'),
    ];
  }
}

class BookingMany extends StatefulWidget {
  final PackageBlocModel selectedPackage;
  final Photographer photographer;
  final List<PackageBlocModel> blocPackages;

  const BookingMany(
      {this.selectedPackage, this.photographer, this.blocPackages});

  @override
  _BookingManyState createState() => _BookingManyState();
}

class _BookingManyState extends State<BookingMany> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  String timeReturnResult = 'Hãy chọn thời gian nhận';
  String endDate = '';
  String editDeadLine = '';
  String startDate = '';
  DateTime lastDate = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    dropDownMenuItems = buildDropdownMenuItems(returnedTypes);
    selectedType = dropDownMenuItems[0].value;

    for (PackageBlocModel package in widget.blocPackages) {
      if (package.supportMultiDays) {
        listPackages.add(package);
      }
    }

    packageDropDownMenuItems = buildPackageDropdownMenuItems(listPackages);
    selectedPackage = widget.selectedPackage;
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

  bool _validateBooking() {
    if (listTimeAndLocation == null) {
      popUp('Địa điểm và thời gian chụp',
          'Xin hãy chọn thời gian chụp và địa điểm');
      return false;
    } else if (listTimeAndLocation.isEmpty) {
      popUp('Địa điểm và thời gian chụp',
          'Xin hãy chọn thời gian chụp và địa điểm');
      return false;
    } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
      popUp('Nhập thời gian nhận', 'Xin hãy chọn thời gian nhận');
      return false;
    } else if (!lastDate.isBefore(DateTime.parse(editDeadLine))) {
      popUp('Thời gian nhận',
          'Thời gian nhận ảnh phải sau ngày chụp cuối ít nhất 1 ngày');
      return false;
    }
    return true;
  }

  _createBooking() async {
    if (_validateBooking()) {
      List<TimeAndLocationBlocModel> timeAndLocations = listTimeAndLocation;

      BookingBlocModel booking = BookingBlocModel(
          serviceName: selectedPackage.name,
          price: selectedPackage.price,
          editDeadLine: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .format(DateTime.parse(editDeadLine)),
          photographer: Photographer(id: widget.photographer.id),
          package: selectedPackage,
          returningType: selectedType.id,
          listTimeAndLocations: timeAndLocations);

      BlocProvider.of<BookingBloc>(context)
          .add(BookingEventCreate(booking: booking));
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
          onPressed: _createBooking,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingStateCreatedSuccess) {
              removeNotice();
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                backgroundColor: Colors.black87,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                isDismissible: false,
                duration: Duration(seconds: 5),
                titleText: Text(
                  "Đặt lịch",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: "Quicksand"),
                ),
                messageText: Text(
                  "Gửi yêu cầu thành công!!",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "Quicksand"),
                ),
              ).show(context);
            }

            if (state is BookingStateLoading) {
              popNotice();
            }
            if (state is BookingStateFailure) {
              removeNotice();
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.FLOATING,
                backgroundColor: Colors.black87,
                reverseAnimationCurve: Curves.decelerate,
                forwardAnimationCurve: Curves.elasticOut,
                isDismissible: false,
                duration: Duration(seconds: 5),
                titleText: Text(
                  "Cập nhật cuộc hẹn",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: "Quicksand"),
                ),
                messageText: Text(
                  "Cập nhật thất bại!!",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "Quicksand"),
                ),
              ).show(context);
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
                          MaterialPageRoute(
                              builder: (context) => BookingManyDetail(
                                    ptgId: widget.photographer.id,
                                    onUpdateList:
                                        (TimeAndLocationBlocModel model) {
                                      listTimeAndLocation.add(model);
                                      if (DateTime.parse(model.start)
                                              .add(Duration(days: 1))
                                              .isAfter(lastDate) ||
                                          DateTime.parse(model.start)
                                              .add(Duration(days: 1))
                                              .isAtSameMomentAs(lastDate)) {
                                        lastDate = DateTime.parse(model.start);
                                      }
                                      setState(() {});
                                    },
                                  )),
                        );
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
                                return BookingManyDetailEdit(
                                  ptgId: widget.photographer.id,
                                  model: listTimeAndLocation[mapEntry.key],
                                  onUpdateList:
                                      (TimeAndLocationBlocModel model) {
                                    listTimeAndLocation[mapEntry.key] = model;
                                    setState(() {});
                                  },
                                );
                              }));
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
                                      DateFormat("dd/MM/yyyy HH:mm a").format(
                                          DateTime.parse(
                                              listTimeAndLocation[mapEntry.key]
                                                  .start)),
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
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
                          lastDay: lastDate,
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
    return Container(
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
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: selectedPackage.name,
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Bao gồm các dịch vụ:',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                            selectedPackage.serviceDtos[mapEntry.key].name,
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
    );
  }

  void goBackToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void popNotice() {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 60),
      title: 'Đang gửi yêu cầu',
      configuration: IconConfiguration(
        icon: Icons.send_to_mobile,
      ),
    );
  }

  void removeNotice() {
    StatusAlert.hide();
  }
}
