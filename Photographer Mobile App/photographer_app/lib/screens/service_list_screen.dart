import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app/models/service_model.dart';
import 'package:photographer_app/screens/service_new_screen.dart';

import 'service_edit_screen.dart';

class ListService extends StatefulWidget {
  @override
  _ListServiceState createState() => _ListServiceState();
}

class _ListServiceState extends State<ListService> {
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Dịch vụ của tôi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            letterSpacing: -1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewService()),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          Service service = services[index];
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        offset: Offset(-1.0, 2.0),
                        blurRadius: 6.0)
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Quicksand',
                                  fontSize: 14.0),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Tên gói:  ',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: services[0].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Bao gồm các dịch vụ:',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            children: services[2]
                                .tasks
                                .asMap()
                                .entries
                                .map((MapEntry mapEntry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      color: Color(0xFFF77474),
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        services[2].tasks[mapEntry.key],
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          Divider(
                            height: 40.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng cộng:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${oCcy.format(services[1].price)} đồng',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                          height: 70,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditService(
                                    service: service,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Chỉnh sửa",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Xóa",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
