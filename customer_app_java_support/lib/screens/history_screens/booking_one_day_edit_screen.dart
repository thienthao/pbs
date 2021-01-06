import 'package:customer_app_java_support/blocs/authen_blocs/authentication_bloc.dart';
import 'package:customer_app_java_support/blocs/authen_blocs/authentication_event.dart';
import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/models/weather_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  WarningRepository _warningRepository =
      WarningRepository(httpClient: http.Client());

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  List<PackageBlocModel> listPackages = List<PackageBlocModel>();
  double cuLat = 0;
  double cuLong = 0;
  DateTime lastDate = DateTime.now();

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

  _getWeatherWarning() async {
    BlocProvider.of<WarningBloc>(context).add(WarningEventGetWeatherWarning(
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate)),
        latLng: selectedLatLng));
  }

  bool _validateBooking() {
    if (timeResult == 'Hãy chọn thời gian chụp') {
      popUp(context, 'Chọn thời gian chụp', 'Xin hãy chọn thời gian chụp');
      return false;
    } else if (timeReturnResult == 'Hãy chọn thời gian nhận') {
      popUp(context, 'Chọn thời gian nhận', 'Xin hãy chọn thời gian nhận');
      return false;
    } else if (locationResult == 'Hãy chọn nơi bạn muốn chụp ảnh') {
      popUp(context, 'Chọn nơi chụp', 'Xin hãy chọn nơi chụp ảnh');
      return false;
    } else if (!lastDate.isBefore(DateTime.parse(endDate))) {
      popUp(context, 'Thời gian nhận',
          'Thời gian nhận ảnh phải sau ngày chụp cuối ít nhất 1 ngày');
      return false;
    }
    return true;
  }

  _logOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
  }

  _editBooking() async {
    if (selectedPackage != null) {
      if (_validateBooking()) {
        List<TimeAndLocationBlocModel> timeAndLocations =
            List<TimeAndLocationBlocModel>();

        TimeAndLocationBlocModel timeAndLocationBlocModel =
            TimeAndLocationBlocModel(
          latitude: selectedLatLng.latitude,
          longitude: selectedLatLng.longitude,
          formattedAddress: locationResult,
          start: DateFormat("yyyy-MM-dd'T'HH:mm")
              .format(DateTime.parse(startDate)),
          end: DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.parse(startDate)
              .add(Duration(
                  hours: (selectedPackage.timeAnticipate / 3600).round()))),
        );
        timeAndLocations.add(timeAndLocationBlocModel);

        BookingBlocModel booking = BookingBlocModel(
            id: widget.bookingBlocModel.id,
            serviceName: packageResult.name,
            price: packageResult.price,
            editDeadLine: DateFormat("yyyy-MM-dd'T'HH:mm")
                .format(DateTime.parse(endDate)),
            photographer: Photographer(id: widget.photographer.id),
            package: packageResult,
            returningType: selectedType.id,
            listTimeAndLocations: timeAndLocations);

        BlocProvider.of<BookingBloc>(context)
            .add(BookingEventEdit(booking: booking, cusId: globalCusId));
      }
    }
  }

  String convertOutLookToVietnamese(String outlook) {
    String result = '';
    switch (outlook) {
      case 'freezing':
        result = 'Trời lạnh';
        break;
      case 'ice':
        result = 'Trời lạnh';
        break;
      case 'rainy':
        result = 'Trời mưa';
        break;
      case 'cloudy':
        result = 'Trời mây';
        break;
      case 'clear':
        result = 'Trời hoang';
        break;
      case 'sunny':
        result = 'Trời nắng';
        break;
    }
    return result;
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
    lastDate =
        DateTime.parse(widget.bookingBlocModel.listTimeAndLocations[0].end)
            .toLocal();
    timeResult = DateFormat('dd/MM/yyyy hh:mm a').format(
        DateTime.parse(widget.bookingBlocModel.listTimeAndLocations[0].start)
            .toLocal());

    timeReturnResult = DateFormat('dd/MM/yyyy hh:mm a')
        .format(DateTime.parse(widget.bookingBlocModel.editDeadLine).toLocal());
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
                                  DateFormat('dd/MM/yyyy hh:mm a').format(
                                      DateTime.parse(startDate).toLocal()),
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
                                  ),
                                  BlocProvider(
                                    create: (context) => WarningBloc(
                                        warningRepository: _warningRepository),
                                  ),
                                  BlocProvider(
                                    create: (context) => WorkingDayBloc(
                                        calendarRepository:
                                            _calendarRepository),
                                  )
                                ],
                                child: BlocDatePicker(
                                  ptgId: widget.photographer.id,
                                  onSelecParam: (DateTime result) {
                                    startDate = result.toString();
                                    lastDate = result;
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
                                  DateFormat('dd/MM/yyyy hh:mm a')
                                      .format(DateTime.parse(endDate)),
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
                                  ),
                                  BlocProvider(
                                    create: (context) => WarningBloc(
                                        warningRepository: _warningRepository),
                                  )
                                ],
                                child: DatePicker(
                                  lastDay: lastDate,
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
                        padding: const EdgeInsets.only(right: 37),
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

                      if (state is PackageStateFailure) {
                        String error =
                            state.error.replaceAll('Exception: ', '');
                        if (error.toUpperCase() == 'UNAUTHORIZED') {
                          _showUnauthorizedDialog();
                        }
                      }
                    },
                    child: Text(''),
                  ),
                  _buildPackage(),
///////////////////////////////////////packages
                  SizedBox(height: 30.0),
                  BlocListener<WarningBloc, WarningState>(
                    listener: (context, state) {
                      if (state is WarningStateLoading) {
                        _showLoadingAlert();
                      }
                      if (state is WarningStateGetWeatherWarningSuccess) {
                        Navigator.pop(context);
                        if (state.notice == null) {
                          _editBooking();
                        } else if (state.notice.humidity == null ||
                            state.notice.noti == null ||
                            state.notice.outlook == null ||
                            state.notice.temperature == null ||
                            state.notice.windSpeed == null) {
                          _editBooking();
                          return;
                        } else {
                          _showWeatherWarning(state.notice);
                        }
                      }

                      if (state is WarningStateFailure) {
                        Navigator.pop(context);
                        String error =
                            state.error.replaceAll('Exception: ', '');
                        if (error.toUpperCase() == 'UNAUTHORIZED') {
                          _showUnauthorizedDialog();
                        } else {
                          _showBookingFailDialog();
                        }
                      }
                    },
                    child: RaisedButton(
                      onPressed: _getWeatherWarning,
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 80.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Cập nhật cuộc hẹn',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
              listener: (context, bookingState) {
                if (bookingState is BookingStateEditedSuccess) {
                  widget.isEdited(true);
                  Navigator.pop(context);
                  _showBookingSuccessAlert();
                  popUp(context, 'Cập nhật cuộc hẹn', 'Cập nhật thành công!');
                }

                if (bookingState is BookingStateLoading) {
                  _showLoadingAlert();
                }

                if (bookingState is BookingStateFailure) {
                  Navigator.pop(context);
                  String error =
                      bookingState.error.replaceAll('Exception: ', '');
                  if (error.toUpperCase() == 'UNAUTHORIZED') {
                    _showUnauthorizedDialog();
                  } else {
                    _showBookingFailDialog();
                    popUp(context, 'Cập nhật cuộc hẹn', 'Cập nhật thất bại!');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showWeatherWarning(WeatherBlocModel notice) async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/alert.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Nhắc nhở',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                '☁ ${convertOutLookToVietnamese(notice.outlook)}   🌡${notice.temperature.round()}°C\n💧${notice.humidity.round()}%       ༄ ${notice.windSpeed.roundToDouble()} m/s\n${notice.noti}',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
                _editBooking();
              },
              onCancelButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: Theme.of(context).scaffoldBackgroundColor,
              buttonCancelText: Text(
                'Trở lại',
                style: TextStyle(color: Colors.black87),
              ),
            ));
  }

  Future<void> _showBookingSuccessAlert() async {
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

  Future<void> _showBookingFailDialog() async {
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
