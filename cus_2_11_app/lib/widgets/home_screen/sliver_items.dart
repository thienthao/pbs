import 'package:cus_2_11_app/screens/home_screens/search_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  double destinationLat = 11.939346;
  double destinationLong = 108.445173;

  getCurrentLocation() async {
    Position position =
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      cuLat = position.latitude;
      cuLong = position.longitude;
      print('${cuLat} + ${cuLat}');
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/images/dalat.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 280.0,
          padding: EdgeInsets.only(
            left: 10.0,
            right: 20.0,
            top: 30.0,
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
                    final pageResult = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchLocation(
                          currentLatitude: cuLat,
                          currentLongitude: cuLong,
                        )));
                    setState(() {
                      locationResult = pageResult;
                      widget.onChangeLocation(locationResult);
                      print(locationResult);
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
                    locationResult.isEmpty ? 'Địa điểm': locationResult['name'],
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
