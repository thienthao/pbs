import 'package:photographer_app_java_support/models/location.dart';
import 'package:flutter/material.dart';

class BottomSheetLocation extends StatefulWidget {
  final Location location;

  BottomSheetLocation({this.location});

  @override
  _BottomSheetLocationState createState() => _BottomSheetLocationState();
}

class _BottomSheetLocationState extends State<BottomSheetLocation> {
  bool sort = false;
  List<Location> selectedLocation;

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
                rows: locations
                    .map(
                      (location) => DataRow(
                        selected: selectedLocation.contains(location),
                        onSelectChanged: (b) {
                          onSelectedRow(b, location);
                        },
                        cells: [
                          DataCell(
                            Text(location.city),
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
        locations.sort((a, b) => a.city.compareTo(b.city));
      } else {
        locations.sort((a, b) => b.city.compareTo(a.city));
      }
    }
  }

  onSelectedRow(bool selected, Location location) async {
    setState(() {
      if (selected) {
        selectedLocation.add(location);
      } else {
        selectedLocation.remove(location);
      }
    });
  }
}
