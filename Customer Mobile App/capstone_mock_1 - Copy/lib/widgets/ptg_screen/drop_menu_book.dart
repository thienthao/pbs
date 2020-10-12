import 'package:flutter/material.dart';

class ServiceTest {
  int id;
  String name;

  ServiceTest(this.id, this.name);

  static List<ServiceTest> getService() {
    return <ServiceTest>[
      ServiceTest(1, 'Gói chụp ảnh thời trang cơ bản'),
      ServiceTest(2, 'Gói chụp ảnh thời trang nâng cao'),
      ServiceTest(3, 'Gói chụp ảnh thời trang cao cấp'),
    ];
  }
}

class DropMenu extends StatefulWidget {

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  List<ServiceTest> services = ServiceTest.getService();

  List<DropdownMenuItem<ServiceTest>> dropDownMenuItems;

  ServiceTest selectedService;

  @override
  void initState() {
    dropDownMenuItems = buildDropdownMenuItems(services);
    selectedService = dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<ServiceTest>> buildDropdownMenuItems(List services) {
    List<DropdownMenuItem<ServiceTest>> items = List();
    for (ServiceTest service in services) {
      items.add(
        DropdownMenuItem(
          value: service,
          child: Text(service.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(ServiceTest newSelectedService) {
    setState(() {
      selectedService = newSelectedService;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    //   DropdownButton(
    //   value: selectedService,
    //   items: dropDownMenuItems,
    //   onChanged: onChangeDropdownItem,
    //   icon: Icon(
    //     Icons.keyboard_arrow_down,
    //     color: Colors.pink,
    //     size: 20.0,
    //   ),
    // );
      DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: selectedService,
            items: dropDownMenuItems,
            onChanged: onChangeDropdownItem,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.pink,
              size: 20.0,
            ),
          ),
        ),
      );
  }
}
