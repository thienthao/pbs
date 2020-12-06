import 'package:customer_app_java_support/constant/city_location.dart';
import 'package:customer_app_java_support/screens/home_screens/search_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SliverItems extends StatefulWidget {
  final Function(Map) onChangeLocation;

  const SliverItems({this.onChangeLocation});
  @override
  _SliverItemsState createState() => _SliverItemsState();
}

class _SliverItemsState extends State<SliverItems> {
  var locationResult = {};
  double cuLat = 0;
  double cuLong = 0;
  String image;

  getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        cuLat = position.latitude;
        cuLong = position.longitude;
        print('$cuLat + $cuLat');
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  image: NetworkImage(
                    image ??
                        'https://i.pinimg.com/564x/52/d2/94/52d294e56bd9dbf4ebb46099753e69ba.jpg',
                  ),
                )),
          ),
        ),
        Container(
          width: 280.0,
          padding: EdgeInsets.only(
            left: 10.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Text(
            'Bạn muốn chụp ảnh ở đâu?',
            style: TextStyle(
              fontSize: 27.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            // overflow: TextOverflow.ellipsis,
            // maxLines: 2,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 105),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.black26,
                  onPressed: () async {
                    final pageResult =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchLocation(
                                  currentLatitude: cuLat,
                                  currentLongitude: cuLong,
                                )));
                    setState(() {
                      locationResult = pageResult;
                      if (locationResult == null) {
                        locationResult = {
                          'name': '',
                          'latlng': LatLng(cuLat, cuLong),
                          'lat': cuLat,
                          'long': cuLong,
                        };
                      }
                      widget.onChangeLocation(locationResult);
                      for (var city in listCityLocations) {
                        print(locationResult['name'].toString());
                        if (locationResult['name']
                                .toString()
                                .compareTo(city.name) ==
                            0) {
                          print(city.image);
                          return image = city.image;
                        } else {
                          image =
                              'https://i.pinimg.com/564x/52/d2/94/52d294e56bd9dbf4ebb46099753e69ba.jpg';
                        }
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.white,
                  ),
                  label: Text(
                    locationResult.isEmpty || locationResult['name'] == ''
                        ? 'Địa điểm'
                        : locationResult['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                locationResult.isEmpty || locationResult['name'] == ''
                    ? SizedBox()
                    : FlatButton.icon(
                        color: Colors.black26,
                        onPressed: () async {
                          getCurrentLocation();
                          setState(() {
                            locationResult = {
                              'name': '',
                              'latlng': LatLng(cuLat, cuLong),
                              'lat': cuLat,
                              'long': cuLong,
                            };
                            image =
                                'https://i.pinimg.com/564x/52/d2/94/52d294e56bd9dbf4ebb46099753e69ba.jpg';
                            widget.onChangeLocation(locationResult);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        label: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
