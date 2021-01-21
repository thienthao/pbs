import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/blocs/working_day_blocs/working_day_bloc.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/models/weather_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:customer_app_java_support/shared/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class BookingManyDetail extends StatefulWidget {
  final int ptgId;
  final int timeAnticipate;
  final Function(TimeAndLocationBlocModel) onUpdateList;

  const BookingManyDetail({this.onUpdateList, this.ptgId, this.timeAnticipate});
  @override
  _BookingManyDetailState createState() => _BookingManyDetailState();
}

class _BookingManyDetailState extends State<BookingManyDetail> {
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
    setState(() {
      cuLat = position.latitude;
      cuLong = position.longitude;
      print('$cuLat + $cuLat');
      location = LatLng(cuLat, cuLong);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getDataAndPop() {
    if (locationResult.compareTo('Hãy chọn nơi bạn muốn chụp ảnh') == 0) {
      popUp(
          context, 'Chọn địa điểm', 'Hãy chọn địa điểm mà bạn muốn chụp ảnh!');
    } else if (timeResult.compareTo('Hãy chọn thời gian chụp') == 0) {
      popUp(context, 'Chọn thời gian chụp', 'Hãy chọn thời gian chụp!');
    } else {
      print(startDate);
      widget.onUpdateList(TimeAndLocationBlocModel(
          start: DateFormat("yyyy-MM-dd'T'HH:mm")
              .format(DateTime.parse(startDate)),
          end: DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.parse(startDate)
              .add(Duration(hours: (widget.timeAnticipate / 3600).round()))),
          latitude: location.latitude,
          longitude: location.longitude,
          formattedAddress: locationResult));
      _getWeatherWarning();
    }
  }

  _getWeatherWarning() async {
    print(
        '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(startDate))}');
    BlocProvider.of<WarningBloc>(context).add(WarningEventGetWeatherWarning(
        timeAnticipate: widget.timeAnticipate,
        dateTime:
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(startDate)),
        latLng: location));
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
                if (state is WarningStateGetWeatherWarningSuccess) {
                  Navigator.pop(context);
                  if (state.notice == null) {
                    Navigator.pop(context);
                  } else if (state.notice.isHourly) {
                    _showWeatherWarningHourlyAlert(state.notice);
                  } else if (!state.notice.isHourly) {
                    if (state.notice.humidity == null ||
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
        title: Text('Thêm ngày chụp'),
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
        builder: (BuildContext aContext) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Material(
                    type: MaterialType.card,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset('assets/images/alert.gif',
                              height: 150,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Nhắc nhở',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  notice.location,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(notice.date,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '☁ ${convertOutLookToVietnamese(notice.outlook)}   🌡${notice.temperature.round()}°C\n💧${notice.humidity.round()}%       ༄ ${notice.windSpeed.roundToDouble()} m/s\n\n${notice.noti}',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.grey[200],
                                  focusColor: Colors.white,
                                  splashColor: Colors.grey[200],
                                  highlightColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side:
                                          BorderSide(color: Colors.grey[200])),
                                  child: Text('Hủy bỏ')),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  color: Theme.of(context).accentColor,
                                  focusColor: Colors.white,
                                  splashColor: Theme.of(context).accentColor,
                                  highlightColor: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).accentColor)),
                                  child: Text(
                                    'Đồng ý',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget convertOutLookToIcon(String outlook) {
    BoxedIcon icon;
    switch (outlook) {
      case 'freezing':
        icon = BoxedIcon(WeatherIcons.day_snow);
        break;
      case 'ice':
        icon = BoxedIcon(WeatherIcons.day_snow);
        break;
      case 'rainy':
        icon = BoxedIcon(WeatherIcons.day_rain);
        break;
      case 'cloudy':
        icon = BoxedIcon(WeatherIcons.day_cloudy);
        break;
      case 'clear':
        icon = BoxedIcon(WeatherIcons.day_sunny_overcast);
        break;
      case 'sunny':
        icon = BoxedIcon(WeatherIcons.day_sunny);
        break;
    }
    return icon;
  }

  Widget buildNoticeHourly(Map time) {
    var widget = <Widget>[];
    time.forEach((key, value) {
      widget.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Text(key),
            SizedBox(
              height: 5,
            ),
            convertOutLookToIcon(value['outlook']),
            SizedBox(
              height: 5,
            ),
            Text('${value['temperature']}°C'),
            SizedBox(
              height: 5,
            ),
            Icon(
              value['isSuitable'] ? Icons.done_rounded : Icons.close_rounded,
              color: value['isSuitable'] ? Colors.green[400] : Colors.red[300],
              size: 30,
            )
          ],
        ),
      ));
    });
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget,
      ),
    );
  }

  Widget _buildNoticeHourlyDetail(Map time) {
    var widget = <Widget>[];
    time.forEach((key, value) {
      widget.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Divider(
              indent: 10,
              endIndent: 10,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thời gian:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(key,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nhiệt độ:'),
                Text('${value['temperature']}°C'),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Độ ẩm:'),
                Text('${value['humidity']}%'),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tốc độ gió:'),
                Text('${value['windSpeed']} m/s'),
              ],
            ),
          ],
        ),
      ));
    });
    return Column(
      children: widget,
    );
  }

  Future<void> _showWeatherWarningHourlyAlert(WeatherBlocModel notice) async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Material(
                    type: MaterialType.card,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset('assets/images/alert.gif',
                              height: 150,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Nhắc nhở',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  notice.location,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(notice.date,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                              ),
                              Text(
                                notice.overall
                                    ? 'Thời tiết huận lợi để chụp ảnh'
                                    : 'Thời tiết không thuận lợi cho chụp ảnh',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                              Divider(
                                indent: 10,
                                endIndent: 10,
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buildNoticeHourly(notice.time),
                              ),
                              _buildNoticeHourlyDetail(notice.time),
                              Divider(
                                indent: 10,
                                endIndent: 10,
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.grey[200],
                                  focusColor: Colors.white,
                                  splashColor: Colors.grey[200],
                                  highlightColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side:
                                          BorderSide(color: Colors.grey[200])),
                                  child: Text('Hủy bỏ')),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  color: Theme.of(context).accentColor,
                                  focusColor: Colors.white,
                                  splashColor: Theme.of(context).accentColor,
                                  highlightColor: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).accentColor)),
                                  child: Text(
                                    'Đồng ý',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
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
