import 'package:ptg_7_11_app/models/category.dart';
import 'package:flutter/material.dart';

class BottomSheetCategory extends StatefulWidget {
  final Category category;

  BottomSheetCategory({this.category});

  @override
  _BottomSheetCategoryState createState() => _BottomSheetCategoryState();
}

class _BottomSheetCategoryState extends State<BottomSheetCategory> {
  bool sort = false;
  List<Category> selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategory = [];
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
                'Chọn category',
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
                        'Tên',
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
                rows: categorys
                    .map(
                      (category) => DataRow(
                        selected: selectedCategory.contains(category),
                        onSelectChanged: (b) {
                          onSelectedRow(b, category);
                        },
                        cells: [
                          DataCell(
                            Text(category.name),
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
              child: Text('Chọn ${selectedCategory.length}'),
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
        categorys.sort((a, b) => a.name.compareTo(b.name));
      } else {
        categorys.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  onSelectedRow(bool selected, Category category) async {
    setState(() {
      if (selected) {
        selectedCategory.add(category);
      } else {
        selectedCategory.remove(category);
      }
    });
  }
}
