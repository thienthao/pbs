import 'package:capstone_mock_1/models/service_model.dart';
import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart' as intl;

class ServiceShow extends StatefulWidget {
  @override
  _ServiceShowState createState() => _ServiceShowState();
}

class _ServiceShowState extends State<ServiceShow> {
  Service _serviceRadio = services[0];
  intl.NumberFormat oCcy = intl.NumberFormat("#,##0", "vi_VN");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: services.asMap().entries.map((MapEntry mapEntry) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                              activeColor: Color(0xFFF77474),
                              value: services[mapEntry.key],
                              groupValue: _serviceRadio,
                              onChanged: (value) {
                                setState(() {
                                  _serviceRadio = value;
                                });
                              }),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              children: [
                                Text(
                                  '${services[mapEntry.key].name}',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Text(
                                      'Thời gian chụp:',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      '${services[mapEntry.key].time}  buổi',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.0),
                                Row(
                                  children: [
                                    Text(
                                      'Giá thành:',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      '${oCcy.format(services[mapEntry.key].price)} đồng',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 40.0,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    Column(
                      children: services[mapEntry.key]
                          .tasks
                          .asMap()
                          .entries
                          .map((MapEntry map) {
                        return Padding(
                          padding: const EdgeInsets.all(
                            10.0,
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
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  services[mapEntry.key].tasks[map.key],
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
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
