import 'package:flutter/material.dart';

class Status {
  int id;
  String name;

  Status(this.id, this.name);

  static List<Status> getStatus() {
    return <Status>[
      Status(1, 'Tất cả'),
      Status(2, 'Chờ xác nhận'),
      Status(3, 'Sắp diễn ra'),
      Status(4, 'Đang hậu kì'),
      Status(5, 'Hoàn thành'),
      Status(6, 'Đã hủy'),
    ];
  }
}

class DropMenu extends StatefulWidget {

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  List<Status> statuss = Status.getStatus();

  List<DropdownMenuItem<Status>> dropDownMenuItems;

  Status selectedStatus;

  @override
  void initState() {
    dropDownMenuItems = buildDropdownMenuItems(statuss);
    selectedStatus = dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Status>> buildDropdownMenuItems(List statuss) {
    List<DropdownMenuItem<Status>> items = List();
    for (Status status in statuss) {
      items.add(
        DropdownMenuItem(
          value: status,
          child: Text(status.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Status newSelectedStatus) {
    setState(() {
      selectedStatus = newSelectedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child:
          DropdownButton(
            value: selectedStatus,
            items: dropDownMenuItems,
            onChanged: onChangeDropdownItem,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.pink,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
