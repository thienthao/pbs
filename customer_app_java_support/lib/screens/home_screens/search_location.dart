import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class SearchLocation extends StatefulWidget {
  final double currentLatitude;
  final double currentLongitude;

  const SearchLocation({this.currentLatitude, this.currentLongitude});

  // bắn qua để init location
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  var returnLocation = {};

  getUserLocation(LatLng location) async {
    try {
      final coordinates =
          new Coordinates(location.latitude, location.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print('${first.adminArea} ${first.coordinates}');
      returnLocation = {
        'name': '${first.adminArea}',
        'latlng': first.coordinates,
        'lat': coordinates.latitude,
        'long': coordinates.longitude,
      };
    } catch (e) {}
  }

  getCurrentLocationCity() async {
    try {
      final coordinates =
          new Coordinates(widget.currentLatitude, widget.currentLongitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print('${first.coordinates} ${first.coordinates}');
      returnLocation = {'name': first.adminArea, 'latlng': first.coordinates};
    } catch (e) {}
  } // thêm để check null

  @override
  void initState() {
    super.initState();
    getCurrentLocationCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController googleMapController) {
              setState(() {
                mapController = googleMapController;
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.currentLatitude, widget.currentLongitude),
              zoom: 16,
            ),
            markers: _markers.values.toSet(),
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
                SearchMapPlaceWidget(
                  language: 'vi',
                  // doi tat ca thanh vi
                  hasClearButton: true,
                  placeType: PlaceType.address,
                  placeholder: 'Nhập địa chỉ',
                  apiKey: 'AIzaSyBP8cODYx872X1l-6jqxTjLClHXdIoAUi4',
                  onSelected: (Place place) async {
                    Geolocation geolocation = await place.geolocation;
                    mapController.animateCamera(
                        CameraUpdate.newLatLng(geolocation.coordinates));
                    mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                    getUserLocation(geolocation.coordinates);
                    setState(() {
                      _markers.clear();
                      final marker = Marker(
                        markerId: MarkerId('${geolocation.coordinates}'),
                        position: geolocation.coordinates,
                      );
                      _markers["Current Location"] = marker;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 380, left: 20, right: 20),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context, returnLocation);
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 80.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Xác nhận',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
