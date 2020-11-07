import 'package:flutter/material.dart';
import 'package:ptg_7_11_app/models/service_bloc_model.dart';

// ignore: must_be_immutable
class MiniListEdit extends StatefulWidget {
  final List<ServiceBlocModel> servicesOfPackage;
  Function(List<ServiceBlocModel>) onChangeParam;

  MiniListEdit({this.servicesOfPackage, this.onChangeParam});
  @override
  _MiniListEditState createState() => _MiniListEditState();
}

class _MiniListEditState extends State<MiniListEdit> {
  var txtController = TextEditingController();
  bool isEditing = false;
  int updateIndex = -1;
  List<ServiceBlocModel> tempServices = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempServices = widget.servicesOfPackage.map((service) {
      return ServiceBlocModel(id: service.id, name: service.name);
    }).toList();
    widget.onChangeParam(tempServices);
  }

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
                        tempServices[updateIndex].name = txtController.text;
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
                        tempServices
                            .add(ServiceBlocModel(name: txtController.text));
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
                  txtController.text = tempServices[index].name;
                  updateIndex = index;
                  isEditing = true;
                  setState(() {});
                },
                child: ListTile(
                  title: Text(
                    tempServices[index].name ?? 'Dịch vụ $index',
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
