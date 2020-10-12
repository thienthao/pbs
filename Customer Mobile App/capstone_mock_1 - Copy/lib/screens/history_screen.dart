import 'package:capstone_mock_1/models/booking_model.dart';
import 'package:capstone_mock_1/widgets/history_screen/top_part_history.dart';
import 'package:flutter/material.dart';

import 'booking_detail_screen.dart';

class BookHistory extends StatefulWidget {
  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử cuộc hẹn',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFFF88F8F),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFF88F8F),
              Color(0xFFF88Fa9),
            ]),
          ),
        ),
      ),
      body: Column(
        children: [
          TopPart(),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                Booking booking = bookings[index];
                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap:() {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation, curve: Curves.elasticInOut);
                                  return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                      alignment: Alignment.center);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return BookingDetailScreen();
                                }));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      'Chụp ảnh với ${booking.ptgname}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Trang thái:',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        booking.status,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: booking.status == 'Sắp diễn ra'
                                              ? Colors.blueAccent
                                              : booking.status == 'Chờ xác nhận'
                                                  ? Colors.amber
                                                  : booking.status == 'Bị từ chối'
                                                      ? Colors.redAccent
                                                      : booking.status ==
                                                              'Hoàn thành'
                                                          ? Colors.lightGreen[400]
                                                          : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.timer,
                                      size: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
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
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      booking.time,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.loyalty,
                                      size: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      'Gói:',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        booking.package,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
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
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                        booking.address,
                                        style: TextStyle(
                                          color: Colors.grey,
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
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
