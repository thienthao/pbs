import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_1_11/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_1_11/models/booking_bloc_model.dart';
import 'package:photographer_app_1_11/respositories/booking_repository.dart';
import 'package:photographer_app_1_11/screens/booking_detail_screen_pen.dart';

class BookingWidget extends StatefulWidget {
  final bool hasReachedEnd;
  final List<BookingBlocModel> blocBookings;
  final Function onGoBack;
  final ScrollController scrollController;

  const BookingWidget(
      {this.blocBookings,
      this.onGoBack,
      this.hasReachedEnd,
      this.scrollController});

  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  Text statusFormat(String status) {
    String text = status;
    Color color = Colors.black;
    if (status.toUpperCase().trim() == 'DONE') {
      text = 'Đã hoàn thành';
      color = Colors.lightGreen[400];
    } else if (status.toUpperCase().trim() == 'PENDING') {
      text = 'Chờ xác nhận';
      color = Colors.amber;
    } else if (status.toUpperCase().trim() == 'REJECTED') {
      text = 'Từ chối';
      color = Colors.redAccent;
    } else if (status.toUpperCase().trim() == 'ONGOING') {
      text = 'Sắp diễn ra';
      color = Colors.blueAccent;
    } else if (status.toUpperCase().trim() == 'EDITING') {
      text = 'Đang hậu kì';
      color = Colors.cyan;
    } else if (status.toUpperCase().trim() == 'CANCELED') {
      text = 'Đã hủy';
      color = Colors.black54;
    }
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.hasReachedEnd
          ? widget.blocBookings.length
          : widget.blocBookings.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index >= widget.blocBookings.length) {
          print(index);
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          BookingBlocModel booking = widget.blocBookings[index];
          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
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
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) => BookingBloc(
                                        bookingRepository: _bookingRepository)),
                              ],
                              child: BookingDetailScreenPen(
                                bookingId: booking.id,
                              ),
                            );
                          })).then(widget.onGoBack);
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
                                'Chụp ảnh với ${booking.customer.fullname} ${booking.id}',
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
                                statusFormat(booking.status),
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
                                booking.startDate == null
                                    ? ''
                                    : DateFormat('dd/MM/yyyy hh:mm a').format(
                                        DateTime.parse(booking.startDate)),
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
                                  booking.serviceName == null
                                      ? ''
                                      : booking.serviceName,
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
                                  booking.location == null
                                      ? ''
                                      : booking.location,
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
        }
      },
    );
  }
}