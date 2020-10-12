import 'dart:async';
import 'package:capstone_mock_1/widgets/ptg_screen/ride_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(11.939346, 108.445173),
                zoom: 16,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Chọn địa điểm chụp",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 310, left: 20, right: 20),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 80.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
