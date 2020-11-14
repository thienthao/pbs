import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DropMenu extends StatefulWidget {
  List<PackageBlocModel> blocPackages;
  PackageBlocModel selectedPackage;
  Function(PackageBlocModel) onSelectParam;

  DropMenu({this.blocPackages, this.selectedPackage, this.onSelectParam});

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  List<DropdownMenuItem<PackageBlocModel>> dropDownMenuItems;
  List<PackageBlocModel> listPackages = List<PackageBlocModel>();

  PackageBlocModel selectedPackage;

  @override
  void initState() {
    for (PackageBlocModel package in widget.blocPackages) {
      if (!package.supportMultiDays) {
        listPackages.add(package);
      }
    }
    dropDownMenuItems = buildDropdownMenuItems(listPackages);
    selectedPackage = widget.selectedPackage;
    super.initState();
  }

  List<DropdownMenuItem<PackageBlocModel>> buildDropdownMenuItems(
      List packages) {
    List<DropdownMenuItem<PackageBlocModel>> items = List();
    for (PackageBlocModel package in packages) {
      items.add(
        DropdownMenuItem(
          value: package,
          child: Text(package.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(PackageBlocModel newSelectedPackage) {
    setState(() {
      selectedPackage = newSelectedPackage;
      widget.onSelectParam(selectedPackage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: selectedPackage,
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
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 15.0,
                left: 55.0,
              ),
              child: Text(
                'Tổng cộng:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                '${oCcy.format(selectedPackage.price)} đồng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}
