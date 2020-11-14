import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/calendar_blocs/calendars.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/calendar_repository.dart';
import 'package:customer_app_java_support/screens/ptg_screens/date_picker_screen_bloc.dart';
import 'package:customer_app_java_support/screens/ptg_screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingManyDetail extends StatefulWidget {
  final int ptgId;
  final Function(TimeAndLocationBlocModel) onUpdateList;

  const BookingManyDetail({this.onUpdateList, this.ptgId});
  @override
  _BookingManyDetailState createState() => _BookingManyDetailState();
}

class _BookingManyDetailState extends State<BookingManyDetail> {
  CalendarRepository _calendarRepository =
      CalendarRepository(httpClient: http.Client());
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
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
    } else if (timeResult.compareTo('Hãy chọn thời gian chụp') == 0) {
    } else {
      print(startDate);
      widget.onUpdateList(TimeAndLocationBlocModel(
          start: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .format(DateTime.parse(startDate)),
          end: DateFormat("yyyy-MM-dd'T'23:59:59.999'Z'")
              .format(DateTime.parse(startDate)),
          latitude: location.latitude,
          longitude: location.longitude,
          formattedAddress: locationResult));
      Navigator.pop(context);
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
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: getDataAndPop,
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
}
