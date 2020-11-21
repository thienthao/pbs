import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class BookingOneDayEditScreen extends StatefulWidget {
  final PackageBlocModel selectedPackage;
  final BookingBlocModel bookingBlocModel;
  final Photographer photographer;
  final Function(bool) isEdited;

  const BookingOneDayEditScreen(
      {this.photographer,
      this.selectedPackage,
      this.bookingBlocModel,
      this.isEdited});

  @override
  _BookingOneDayEditScreenState createState() =>
      _BookingOneDayEditScreenState();
}

class _BookingOneDayEditScreenState extends State<BookingOneDayEditScreen> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  List<PackageBlocModel> listPackages = List<PackageBlocModel>();
  double cuLat = 0;
  double cuLong = 0;

  List<ReturnTypeModel> returnedTypes = ReturnTypeModel.getReturnTypes();
  List<DropdownMenuItem<ReturnTypeModel>> dropDownMenuItems;
  ReturnTypeModel selectedType;
  LatLng selectedLatLng;

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

  List<DropdownMenuItem<PackageBlocModel>> packageDropDownMenuItems;
  PackageBlocModel selectedPackage;

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
      packageResult = selectedPackage;
    });
  }

  _editBooking() async {
    if (selectedPackage != null) {
      var startDateTemp =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(startDate));
      var endDateTemp =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(endDate));
      if (timeResult == 'Hãy chọn thời gian chụp') {
        validateNotice('Mời bạn chọn thời gian chụp');
      } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
        validateNotice('Mời bạn chọn thời gian nhận ảnh');
      } else if (locationResult == 'Hãy chọn nơi bạn muốn chụp ảnh') {
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
          end: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .format(DateTime.parse(startDate).add(Duration(hours: 6))),
        );
        timeAndLocations.add(timeAndLocationBlocModel);

        BookingBlocModel booking = BookingBlocModel(
            id: widget.bookingBlocModel.id,
            serviceName: packageResult.name,
            price: packageResult.price,
            editDeadLine: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(DateTime.parse(endDate)),
            photographer: Photographer(id: widget.photographer.id),
            package: packageResult,
            returningType: selectedType.id,
            listTimeAndLocations: timeAndLocations);

        BlocProvider.of<BookingBloc>(context)
            .add(BookingEventEdit(booking: booking));
      }
    }
  }

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

  Widget _buildPackage() {
    return selectedPackage != null
        ? Column(
            children: [
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
                padding: EdgeInsets.all(5),
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
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
                        selectedPackage != null
                            ? Column(
                                children: selectedPackage.serviceDtos
                                    .asMap()
                                    .entries
                                    .map((MapEntry mapEntry) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              )
                            : SizedBox(),
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
                            selectedPackage != null
                                ? Text(
                                    '${oCcy.format(selectedPackage.price)} đồng',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '0 đồng',
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

  @override
  void initState() {
    super.initState();
    startDate = widget.bookingBlocModel.listTimeAndLocations[0].start;
    endDate = widget.bookingBlocModel.editDeadLine;
    timeResult = DateFormat('dd/MM/yyyy HH:mm a').format(
        DateTime.parse(widget.bookingBlocModel.listTimeAndLocations[0].start));

    timeReturnResult = DateFormat('dd/MM/yyyy HH:mm a')
        .format(DateTime.parse(widget.bookingBlocModel.editDeadLine));
    locationResult =
        widget.bookingBlocModel.listTimeAndLocations[0].formattedAddress;
    dropDownMenuItems = buildDropdownMenuItems(returnedTypes);
    selectedType = dropDownMenuItems[0].value;
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Chỉnh sửa cuộc hẹn',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: BlocListener<BookingBloc, BookingState>(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0, top: 20.0),
                      child: Text(
                        'Chụp ảnh với ${widget.photographer.fullname}',
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
                                        calendarRepository:
                                            _calendarRepository),
                                  ),
                                  BlocProvider(
                                    create: (context) => BookingBloc(
                                        bookingRepository: _bookingRepository),
                                  )
                                ],
                                child: BlocDatePicker(
                                  ptgId: widget.photographer.id,
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
                                        calendarRepository:
                                            _calendarRepository),
                                  ),
                                  BlocProvider(
                                    create: (context) => BookingBloc(
                                        bookingRepository: _bookingRepository),
                                  )
                                ],
                                child: BlocDatePicker(
                                  ptgId: widget.photographer.id,
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
                            final pageResult = await Navigator.of(context)
                                .push(MaterialPageRoute(
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
                        padding: const EdgeInsets.only(right: 70),
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
///////////////////////////////////////packages

                  BlocListener<PackageBloc, PackageState>(
                    listener: (context, state) {
                      if (state is PackageStateSuccess) {
                        for (PackageBlocModel package in state.packages) {
                          if (!package.supportMultiDays) {
                            listPackages.add(package);
                          }
                        }

                        for (var item in state.packages) {
                          if (item.id == widget.selectedPackage.id) {
                            packageResult = selectedPackage = item;
                          }
                        }
                        packageDropDownMenuItems =
                            buildPackageDropdownMenuItems(listPackages);

                        setState(() {});
                      }
                      if (state is PackageStateLoading) {
                        return CircularProgressIndicator();
                      }
                    },
                    child: Text(''),
                  ),
                  _buildPackage(),
///////////////////////////////////////packages
                  SizedBox(height: 30.0),
                  RaisedButton(
                    onPressed: _editBooking,
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Đặt dịch vụ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
              listener: (context, bookingState) {
                if (bookingState is BookingStateEditedSuccess) {
                  widget.isEdited(true);
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
                      "Cập nhật thành công!!",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: "Quicksand"),
                    ),
                  ).show(context);
                }

                if (bookingState is BookingStateLoading) {
                  popNotice();
                }

                if (bookingState is BookingStateFailure) {
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
            ),
          ),
        ],
      ),
    );
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
