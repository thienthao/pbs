import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/blocs/working_day_blocs/working_days.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/models/weather_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingManyDetailEdit extends StatefulWidget {
  final int ptgId;
  final Function(TimeAndLocationBlocModel) onUpdateList;
  final TimeAndLocationBlocModel model;
  const BookingManyDetailEdit({this.model, this.onUpdateList, this.ptgId});
  @override
  _BookingManyDetailEditState createState() => _BookingManyDetailEditState();
}

class _BookingManyDetailEditState extends State<BookingManyDetailEdit> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  WarningRepository _warningRepository =
      WarningRepository(httpClient: http.Client());
  String locationResult = 'Hãy chọn nơi bạn muốn chụp ảnh';
  String timeResult = 'Hãy chọn thời gian chụp';
  String startDate = '';
  double cuLat = 0;
  double cuLong = 0;
  LatLng location;

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        cuLat = position.latitude;
        cuLong = position.longitude;
        location = LatLng(cuLat, cuLong);
      });
    }
  }

  _getWeatherWarning() async {
    BlocProvider.of<WarningBloc>(context).add(WarningEventGetWeatherWarning(
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate)),
        latLng: location));
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    locationResult = widget.model.formattedAddress;
    timeResult = DateFormat("dd/MM/yyyy hh:mm a")
        .format(DateTime.parse(widget.model.start));
    startDate = DateFormat("yyyy-MM-dd'T'HH:mm")
        .format(DateTime.parse(widget.model.start));
    location = LatLng(widget.model.latitude, widget.model.longitude);
  }

  void getDataAndPop() {
    if (locationResult.compareTo('Hãy chọn nơi bạn muốn chụp ảnh') == 0) {
    } else if (timeResult.compareTo('Hãy chọn thời gian chụp') == 0) {
    } else {
      print(startDate);
      widget.onUpdateList(TimeAndLocationBlocModel(
          start: DateFormat("yyyy-MM-dd'T'HH:mm")
              .format(DateTime.parse(startDate)),
          end: widget.model.end,
          latitude: location.latitude,
          longitude: location.longitude,
          formattedAddress: locationResult));
      _getWeatherWarning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocListener<WarningBloc, WarningState>(
            listener: (context, state) {
              if (state is WarningStateLoading) {
                _showLoadingAlert();
              }
              if (state is WarningStateGetWeatherWarningSuccess) {
                Navigator.pop(context);
                if (state.notice == null) {
                  Navigator.pop(context);
                  return;
                } else if (state.notice.humidity == null ||
                    state.notice.noti == null ||
                    state.notice.outlook == null ||
                    state.notice.temperature == null ||
                    state.notice.windSpeed == null) {
                  Navigator.pop(context);
                  return;
                } else {
                  _showWeatherWarning(state.notice);
                }
              }

              if (state is WarningStateFailure) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.blue,
              ),
              onPressed: getDataAndPop,
            ),
          ),
        ],
        title: Text('Chỉnh sửa ngày chụp'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Địa điểm: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                SizedBox(height: 15.0),
                InkWell(
                  onTap: () async {
                    final pageResult =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MapPicker(
                                  currentLatitude: cuLat,
                                  currentLongitude: cuLong,
                                  onSelectedLatLgn: (LatLng latlng) {
                                    if (latlng != null) {
                                      location = latlng;
                                    }
                                  },
                                )));
                    setState(() {
                      if (pageResult != null) {
                        locationResult = pageResult;
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          locationResult,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thời gian bắt đầu chụp: *',
                  style: TextStyle(color: Colors.black87, fontSize: 12.0),
                ),
                SizedBox(height: 15.0),
                InkWell(
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
                          ),
                          BlocProvider(
                            create: (context) => WarningBloc(
                                warningRepository: _warningRepository),
                          ),
                          BlocProvider(
                            create: (context) => WorkingDayBloc(
                                calendarRepository: _calendarRepository),
                          )
                        ],
                        child: BlocDatePicker(
                          ptgId: widget.ptgId,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeResult,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
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
              ],
            ),
          ],
        ),
      ),
    );
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
                Navigator.pop(context);
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
}
