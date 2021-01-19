import 'package:flutter/material.dart';

class Status {
  int id;
  String name;
  String key;

  Status(this.id, this.name, this.key);

  static List<Status> getStatus() {
    return <Status>[
      Status(1, 'Tất cả', 'ALL'),
      Status(2, 'Chờ xác nhận', 'pending'),
      Status(3, 'Sắp diễn ra', 'ongoing'),
      Status(4, 'Đang hậu kì', 'editing'),
      Status(5, 'Hoàn thành', 'done'),
      Status(6, 'Chờ hủy', 'cancelling'),
      Status(7, 'Đã hủy', 'canceled'),
      Status(8, 'Đã từ chối', 'rejected'),
    ];
  }
}

class DropMenu extends StatefulWidget {
  final Function(String) onSelectParam;

  const DropMenu({this.onSelectParam});
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
      widget.onSelectParam(selectedStatus.key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
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
      ),
    );
  }
}
