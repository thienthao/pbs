import 'package:flutter/material.dart';
import 'package:photographer_app/models/service_model.dart';
import 'package:photographer_app/widgets/mini_service_header.dart';
import 'package:photographer_app/widgets/mini_service_list_edit.dart';

class EditService extends StatefulWidget {

  final Service service;

  EditService({this.service});

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  var txt1 = TextEditingController();
  var txt2 = TextEditingController();
  var txt3 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txt1.text = widget.service.name;
    txt2.text = widget.service.price.toString();
    txt3.text = widget.service.time.toString() + ' giờ';
  }

  @override
  void dispose() {
    // other dispose methods
    txt1.dispose();
    txt2.dispose();
    txt3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Chỉnh sửa dịch vụ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(height: 5.0),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tên dịch vụ:',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: txt1,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập tên dịch vụ của bạn',
                              hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Giá thành dịch vụ:',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: txt2,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập giá thành dịch vụ',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Thời gian tác nghiệp:',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: txt3,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Nhập thời gian tác nghiệp dự kiến',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Chi tiết dịch vụ:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0),
                      ),
                      MiniHeader(),
                      SizedBox(height: 10.0),
                      MiniListEdit(),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          width: 300,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Hoàn thành',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
