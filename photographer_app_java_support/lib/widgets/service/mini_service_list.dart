import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MiniList extends StatefulWidget {
  Function(List<String>) onChangeParam;
  MiniList({
    this.onChangeParam,
  });
  @override
  _MiniListState createState() => _MiniListState();
}

class _MiniListState extends State<MiniList> {
  TextEditingController txtController = TextEditingController();
  List<String> tempServices = [];
  bool isEditing = false;
  int updateIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: txtController,
                decoration: InputDecoration(
                    labelText: 'Thêm dịch vụ',
                    labelStyle: TextStyle(
                      fontSize: 13.0,
                    ),
                    hintText: 'Thêm...',
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                    )),
              ),
            ),
            SizedBox(width: 20.0),
            isEditing
                ? IconButton(
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.pink,
                      size: 25.0,
                    ),
                    onPressed: () {
                      if (txtController.text != '') {
                        tempServices[updateIndex] = txtController.text;
                        txtController.clear();
                        isEditing = false;
                        widget.onChangeParam(tempServices);
                      }
                      setState(() {});
                    })
                : IconButton(
                    icon: Icon(
                      Icons.add_rounded,
                      color: Colors.pink,
                      size: 25.0,
                    ),
                    onPressed: () {
                      if (txtController.text != '') {
                        tempServices.add(txtController.text);
                        txtController.clear();
                        widget.onChangeParam(tempServices);
                      }
                      setState(() {});
                    })
          ],
        ),
        Container(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: tempServices.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  txtController.text = tempServices[index];
                  updateIndex = index;
                  isEditing = true;
                  setState(() {});
                },
                child: ListTile(
                  title: Text(
                    tempServices[index],
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      tempServices.removeAt(index);
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
