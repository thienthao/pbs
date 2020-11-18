import 'dart:io';

import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/globals.dart' as globals;
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/screens/home_screens/home_screen.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:http/http.dart' as http;
import 'drop_menu_book.dart';

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

class BottomSheetShow extends StatefulWidget {
  final PackageBlocModel selectedPackage;
  final Photographer photographerName;
  final List<PackageBlocModel> blocPackages;

  const BottomSheetShow(
      {this.photographerName, this.blocPackages, this.selectedPackage});

  @override
  _BottomSheetShowState createState() => _BottomSheetShowState();
}

class _BottomSheetShowState extends State<BottomSheetShow> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  double cuLat = 0;
  double cuLong = 0;
  List<ReturnTypeModel> returnedTypes = ReturnTypeModel.getReturnTypes();
  List<DropdownMenuItem<ReturnTypeModel>> dropDownMenuItems;
  ReturnTypeModel selectedType;
  LatLng selectedLatLng;

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
            style: TextStyle(fontSize: 14),
          ),
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

  String selectedItem = '';
  dynamic result;
  String timeResult = 'Hãy chọn thời gian chụp';
  String timeReturnResult = 'Hãy chọn thời gian nhận';
  String locationResult = 'Hãy chọn nơi bạn muốn chụp ảnh';

  String startDate = '';
  String endDate = '';
  String location = '';
  double latitude;
  double longitude;

  PackageBlocModel packageResult;

  getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        cuLat = position.latitude;
        cuLong = position.longitude;
        selectedLatLng = LatLng(cuLat, cuLong);
        print('$cuLat + $cuLat');
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    packageResult = widget.selectedPackage;
    dropDownMenuItems = buildDropdownMenuItems(returnedTypes);
    selectedType = dropDownMenuItems[0].value;
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingStateCreatedSuccess) {
            if (!bookingState.isSuccess) {
              return Text(
                'Thất bại',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                popNotice();
              });
            }
          }

          if (bookingState is BookingStateFailure) {
            StatusAlert.show(
              context,
              duration: Duration(seconds: 2),
              title: 'Gửi yêu cầu thất bại',
              configuration: IconConfiguration(
                icon: Icons.error_outline_outlined,
              ),
            );
          }
          return Column(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  width: MediaQuery.of(context).size.width * 0.15,
                  margin: EdgeInsets.only(top: 10.0),
                  height: 3.0,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 15.0, top: 20.0),
                  child: Text(
                    'Đặt lịch với ${widget.photographerName.fullname}',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                margin: const EdgeInsets.only(left: 15.0, right: 310.0),
                height: 3.0,
              ),
              SizedBox(height: 20.0),
              Container(
                child: Text(
                  'Thông tin chi tiết',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    wordSpacing: -1,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: 15),
                    child: Icon(
                      Icons.timer,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 28.0,
                    ),
                    child: Text(
                      'Thời gian chụp:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              timeResult,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
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
                            child: BlocDatePicker(
                              ptgId: widget.photographerName.id,
                              onSelecParam: (DateTime result) {
                                startDate = result.toString();
                              },
                            ),
                          );
                        }));
                        setState(() {
                          if (pageResult != null) {
                            timeResult = pageResult;
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.pink,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: 15),
                    child: Icon(
                      Icons.timer,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 20.0,
                    ),
                    child: Text(
                      'Thời gian nhận:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              timeReturnResult,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
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
                            child: BlocDatePicker(
                              ptgId: widget.photographerName.id,
                              onSelecParam: (DateTime result) {
                                endDate = result.toString();
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
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.pink,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: 15),
                    child: Icon(
                      Icons.location_on,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 40.0,
                    ),
                    child: Text(
                      'Địa điểm:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        width: 200,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            locationResult,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final pageResult =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MapPicker(
                                      currentLatitude: cuLat,
                                      currentLongitude: cuLong,
                                      onSelectedLatLgn: (LatLng latlng) {
                                        if (latlng != null) {
                                          selectedLatLng = latlng;
                                        }
                                      },
                                    )));
                        setState(() {
                          if (pageResult != null) {
                            locationResult = pageResult;
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.pink,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: 15),
                    child: Icon(
                      Icons.delivery_dining,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      'Giao trả:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 200.0,
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
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: 15),
                    child: Icon(
                      Icons.loyalty,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Gói dịch vụ:',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08, right: 15),
                child: DropMenu(
                  blocPackages: widget.blocPackages,
                  selectedPackage: widget.selectedPackage,
                  onSelectParam: (PackageBlocModel package) {
                    packageResult = package;
                  },
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                onPressed: () {
                  print(startDate);
                  var startDateTemp = DateFormat("yyyy-MM-dd")
                      .format(DateTime.parse(startDate));
                  var endDateTemp =
                      DateFormat("yyyy-MM-dd").format(DateTime.parse(endDate));
                  if (timeResult == 'Hãy chọn thời gian chụp') {
                    validateNotice('Mời bạn chọn thời gian chụp');
                  } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
                    validateNotice('Mời bạn chọn thời gian nhận ảnh');
                  } else if (locationResult ==
                      'Hãy chọn nơi bạn muốn chụp ảnh') {
                    validateNotice('Mời bạn chọn nơi chụp ảnh');
                  } else if (DateTime.parse(startDateTemp)
                              .compareTo(DateTime.parse(endDateTemp)) +
                          1 >
                      1) {
                    validateNotice(
                        'Thời gian nhận ảnh phải sau thời gian chụp ít nhất 1 ngày');
                  } else {
                    List<TimeAndLocationBlocModel> timeAndLocations =
                        List<TimeAndLocationBlocModel>();

                    TimeAndLocationBlocModel timeAndLocationBlocModel =
                        TimeAndLocationBlocModel(
                      latitude: selectedLatLng.latitude,
                      longitude: selectedLatLng.longitude,
                      formattedAddress: locationResult,
                      start: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .format(DateTime.parse(startDate)),
                      end: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
                          DateTime.parse(startDate).add(Duration(hours: 6))),
                    );
                    timeAndLocations.add(timeAndLocationBlocModel);

                    BookingBlocModel booking = BookingBlocModel(
                        serviceName: packageResult.name,
                        price: packageResult.price,
                        editDeadLine: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                            .format(DateTime.parse(endDate)),
                        photographer:
                            Photographer(id: widget.photographerName.id),
                        package: packageResult,
                        returningType: selectedType.id,
                        listTimeAndLocations: timeAndLocations);

                    BlocProvider.of<BookingBloc>(context)
                        .add(BookingEventCreate(booking: booking));
                    // selectItem('Done');
                  }
                },
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Đặt dịch vụ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void popNotice() {
    globals.selectedTabGlobal = 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });

    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Gửi yêu cầu thành công ',
      configuration: IconConfiguration(
        icon: Icons.done,
      ),
    );
  }

  void validateNotice(String name) async {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: name,
      titleOptions:
          StatusAlertTextConfiguration(style: TextStyle(fontSize: 18)),
      configuration: IconConfiguration(
        icon: Icons.error_outline_outlined,
      ),
    );
  }
}
