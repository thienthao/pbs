import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/profile_screen/map_picker_screen.dart';

// ignore: must_be_immutable
class MiniLocationsListEdit extends StatefulWidget {
  final List<LocationBlocModel> listLocations;
  Function(List<LocationBlocModel>) onChangeParam;

  MiniLocationsListEdit({this.listLocations, this.onChangeParam});
  @override
  _MiniLocationsListEditState createState() => _MiniLocationsListEditState();
}

class _MiniLocationsListEditState extends State<MiniLocationsListEdit> {
  var txtController = TextEditingController();
  bool isEditing = false;
  int updateIndex = -1;
  double cuLat = 0;
  double cuLong = 0;
  LatLng selectedLatLng;
  String locationResult = '';

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

  List<LocationBlocModel> tempListLocations = [];
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    print(widget.listLocations);
    tempListLocations = widget.listLocations.map((location) {
      return LocationBlocModel(
          id: location.id,
          formattedAddress: location.formattedAddress,
          latitude: location.latitude,
          longitude: location.longitude);
    }).toList();
    widget.onChangeParam(tempListLocations);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
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
                tempListLocations.add(LocationBlocModel(
                    latitude: selectedLatLng.latitude,
                    longitude: selectedLatLng.longitude,
                    formattedAddress: pageResult));
                widget.onChangeParam(tempListLocations);
              }
            });
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
              width: 320.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Color(0xFFF1E4F2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      'Thêm địa điểm làm việc',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: tempListLocations.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // txtController.text = tempListLocations[index].name;
                  updateIndex = index;
                  setState(() {});
                },
                child: ListTile(
                  leading: Icon(Icons.my_location_sharp,
                      color: Theme.of(context).primaryColor),
                  title: Text(
                    tempListLocations[index].formattedAddress ??
                        'Địa chỉ $index',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      tempListLocations.removeAt(index);
                      if (tempListLocations.isEmpty) {}
                      setState(() {});
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.pink,
                      size: 15.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
