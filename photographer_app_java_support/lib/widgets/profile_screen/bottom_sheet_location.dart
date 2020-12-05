import 'package:photographer_app_java_support/constant/city_location.dart';
import 'package:flutter/material.dart';
import 'package:photographer_app_java_support/models/location_bloc_model.dart';

class BottomSheetLocation extends StatefulWidget {
  final List<LocationBlocModel> inputList;
  final Function(List<LocationBlocModel>) onSelecteListLocation;
  BottomSheetLocation({this.inputList, this.onSelecteListLocation});

  @override
  _BottomSheetLocationState createState() => _BottomSheetLocationState();
}

class _BottomSheetLocationState extends State<BottomSheetLocation> {
  bool sort = false;
  List<LocationBlocModel> selectedLocation;
  List<LocationBlocModel> photographerLocations = List<LocationBlocModel>();
  @override
  void initState() {
    super.initState();
    selectedLocation = widget.inputList;
    for (var item in listCityLocations) {
      photographerLocations.add(LocationBlocModel(
          formattedAddress: item.name,
          latitude: item.latLng.latitude,
          longitude: item.latLng.longitude));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10.0),
              Text(
                'Chọn địa điểm làm việc',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              DataTable(
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                      label: Text(
                        'Thành phố',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      numeric: false,
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          sort = !sort;
                        });
                        onSortColumn(columnIndex, ascending);
                      }),
                ],
                rows: photographerLocations
                    .map(
                      (location) => DataRow(

                        selected: selectedLocation.contains(location),
                        onSelectChanged: (b) {
                          onSelectedRow(b, location);
                        },
                        cells: [
                          DataCell(
                            Text(location.formattedAddress),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text('Chọn ${selectedLocation.length}'),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        photographerLocations
            .sort((a, b) => a.formattedAddress.compareTo(b.formattedAddress));
      } else {
        photographerLocations
            .sort((a, b) => b.formattedAddress.compareTo(a.formattedAddress));
      }
    }
  }

  onSelectedRow(bool selected, LocationBlocModel location) async {
    setState(() {
      if (selected) {
        selectedLocation.add(location);
      } else {
        selectedLocation.remove(location);
      }
      widget.onSelecteListLocation(selectedLocation);
      
    });
  }
}
