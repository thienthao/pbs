import 'package:cus_2_11_app/models/location.dart';
import 'package:cus_2_11_app/widgets/profile_screen/bottom_sheet_location.dart';
import 'package:flutter/material.dart';
class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<Location> selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text('Chỉnh sửa trang cá nhân'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Họ tên: *',
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.account_circle),
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Ví dụ: Nguyễn Văn A',
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Email: *',
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Ví dụ: abc@xzy.com',
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Số điện thoại: *',
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Ví dụ: 012345678',
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Địa điểm làm việc: *',
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    SizedBox(height: 5.0),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => onPressedButton(),
                          ),
                          locationChips(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Mô tả: *',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 12.0),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.subject),
                            contentPadding: EdgeInsets.all(8.0),
                            hintText: 'Ví dụ: Tôi là....',
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  locationChips() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List<Widget>.generate(locations.length, (int index) {
        Location location = locations[index];
        return Chip(
          label: Text(location.city),
          onDeleted: () {
            setState(() {
              locations.removeAt(index);
            });
          },
        );
      }),
    );
  }

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          color: Color(0xFF737373),
          child: Container(
            child: BottomSheetLocation(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
