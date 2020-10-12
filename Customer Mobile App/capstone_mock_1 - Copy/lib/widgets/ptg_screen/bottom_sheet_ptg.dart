import 'package:capstone_mock_1/screens/date_picker_screen.dart';
import 'package:capstone_mock_1/screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

import 'drop_menu_book.dart'; 

class BottomSheetShow extends StatefulWidget {
  @override
  _BottomSheetShowState createState() => _BottomSheetShowState();
}

class _BottomSheetShowState extends State<BottomSheetShow> {
  String selectedItem = '';
  dynamic result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20.0),
          margin: EdgeInsets.only(right: 70.0),
          child: Text(
            'Đặt lịch với thợ chụp ảnh',
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 3.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: const EdgeInsets.only(left: 15.0, right: 310.0),
          height: 3.0,
        ),
        SizedBox(height: 20.0),
        Container(
          child: Text(
            'Thông tin chi tiết',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
              wordSpacing: -1,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 25.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08, right: 15),
              child: Icon(
                Icons.person,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 90.0,
              ),
              child: Text(
                'Photographer:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('Minh Khoa'),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08, right: 15),
              child: Icon(
                Icons.timer,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 60.0,
              ),
              child: Text(
                'Thời gian:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              child: Text('15/11/2020 - 8:00 AM'),
              onTap: () {
                result = Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatePicker()),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.pink,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08, right: 15),
              child: Icon(
                Icons.location_on,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 40.0,
              ),
              child: Text(
                'Địa điểm:',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: GestureDetector(
                child: Text(
                  'Quảng trường Lâm Viên, Đà Lạt, Lâm Đồng',
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  result = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPicker()),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.pink,
                size: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08, right: 15),
              child: Icon(
                Icons.loyalty,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'Gói dịch vụ:',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.08, right: 15),
          child: DropMenu(),
        ),
        SizedBox(height: 30.0),
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
                '5.000.000 đồng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        RaisedButton(
          onPressed: () => selectItem('Done'),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            'Đặt dịch vụ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void selectItem(String name) {
    setState(() {
      selectedItem = name;
    });
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Gửi yêu cầu thành công',
      configuration: IconConfiguration(
        icon: Icons.done,
      ),
    );
    Navigator.pop(context);
  }
}
