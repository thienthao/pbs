import 'package:photographer_app_java_support/constant/city_location.dart';
import 'package:flutter/material.dart';

class BottomSheetLocation extends StatefulWidget {
  final CityLocation location;

  BottomSheetLocation({this.location});

  @override
  _BottomSheetLocationState createState() => _BottomSheetLocationState();
}

class _BottomSheetLocationState extends State<BottomSheetLocation> {
  bool sort = false;
  List<CityLocation> selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = [];
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
                rows: listCityLocations
                    .map(
                      (location) => DataRow(
                        selected: selectedLocation.contains(location),
                        onSelectChanged: (b) {
                          onSelectedRow(b, location);
                        },
                        cells: [
                          DataCell(
                            Text(location.name),
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
        listCityLocations.sort((a, b) => a.name.compareTo(b.name));
      } else {
        listCityLocations.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  onSelectedRow(bool selected, CityLocation location) async {
    setState(() {
      if (selected) {
        selectedLocation.add(location);
      } else {
        selectedLocation.remove(location);
      }
    });
  }
}
