import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app/models/booking_bloc_model.dart';
import 'package:photographer_app/models/customer_bloc_model.dart';
import 'package:photographer_app/models/service_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailScreenPen extends StatefulWidget {
  final int bookingId;

  const BookingDetailScreenPen({this.bookingId});
  @override
  _BookingDetailScreenPenState createState() => _BookingDetailScreenPenState();
}

class _BookingDetailScreenPenState extends State<BookingDetailScreenPen> {
  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  Completer<void> _completer;

  BookingBlocModel bookingObj;
  _loadBookingDetail() async {
    context
        .bloc<BookingBloc>()
        .add(BookingEventDetailFetch(id: widget.bookingId));
  }

  _acceptBooking(BookingBlocModel _booking) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    context.bloc<BookingBloc>().add(BookingEventAccept(booking: bookingTemp));
  }

  _rejectBooking(BookingBlocModel _booking) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    context.bloc<BookingBloc>().add(BookingEventReject(booking: bookingTemp));
  }

  @override
  void initState() {
    super.initState();
    _loadBookingDetail();
  }

  Widget formatBottomComponentBasedOnStatus(String status) {
    if (status.toUpperCase().trim() == 'DONE') {
    } else if (status.toUpperCase().trim() == 'PENDING') {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              minWidth: 150.0,
              height: 60.0,
              color: Colors.white,
              onPressed: () {
                _rejectBooking(bookingObj);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Hủy',
                  style: TextStyle(fontSize: 21.0, color: Colors.black87),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            ButtonTheme(
              buttonColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minWidth: 180.0,
              height: 60.0,
              child: RaisedButton(
                onPressed: () {
                  _acceptBooking(bookingObj);
                  // Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Đồng ý',
                    style: TextStyle(fontSize: 21.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (status.toUpperCase().trim() == 'REJECTED') {
    } else if (status.toUpperCase().trim() == 'ONGOING') {
      return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                color: Color(0xFFF77474),
                onPressed: () {
                  // _showMyDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Hủy',
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (status.toUpperCase().trim() == 'CANCELED') {
    } else if (status.toUpperCase().trim() == 'EDIT') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Phương thức giao hàng',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                wordSpacing: -1,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-1.0, 2.0),
                    blurRadius: 6.0)
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: 1,
                  title: Text(
                    'Giao hàng qua ứng dụng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Nhập đường link hình ảnh cần giao',
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    // setSelectedRadio(val);
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: 1,
                  title: Text(
                    'Gặp mặt khách hàng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (val) {
                    // setSelectedRadio(val);
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                minWidth: 150.0,
                height: 60.0,
                color: Colors.white,
                onPressed: () {
                  // _showMyDialog();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Hủy',
                    style: TextStyle(fontSize: 21.0, color: Colors.black87),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              ButtonTheme(
                buttonColor: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: 180.0,
                height: 60.0,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Hoàn thành',
                      style: TextStyle(fontSize: 21.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Text('No result matching with this status');
  }

  TextSpan statusFormat(String status) {
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
    } else if (status.toUpperCase().trim() == 'CANCELED') {
      text = 'Đã hủy';
      color = Colors.black;
    }

    return TextSpan(
      text: text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Thông tin chi tiết',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          Center(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, bookingState) {
                if (bookingState is BookingDetailStateSuccess) {
                  bookingObj = bookingState.booking;
                  if (bookingState.booking == null) {
                    return Text(
                      'Đà Lạt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () {
                        _loadBookingDetail();
                        return _completer.future;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Trạng thái, thời gian & địa điểm',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                wordSpacing: -1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(-1.0, 2.0),
                                    blurRadius: 6.0)
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Quicksand'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Trạng thái:   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            statusFormat(
                                                bookingState.booking.status),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Quicksand'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Thời gian:   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: DateFormat(
                                                        'dd/MM/yyyy hh:mm a')
                                                    .format(DateTime.parse(
                                                        bookingState.booking
                                                            .startDate)),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Quicksand'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    'Thời gian tác nghiệp dự kiến:   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: '6 giờ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Quicksand'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Thời gian trả ảnh:   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: DateFormat(
                                                        'dd/MM/yyyy hh:mm a')
                                                    .format(DateTime.parse(
                                                        bookingState
                                                            .booking.endDate)),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                text: '',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Quicksand'),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Địa điểm:  ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: bookingState
                                                          .booking.location,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.location_pin,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
///////////////////////////////////////////////////////////////////////// Khách
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Thông tin khách hàng',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                wordSpacing: -1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(-1.0, 2.0),
                                    blurRadius: 6.0)
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                bookingState
                                                    .booking.customer.avatar,
                                              ),
                                              radius: 30,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                                bookingState
                                                    .booking.customer.fullname,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons
                                                    .phone_android_outlined),
                                                onPressed: null),
                                            IconButton(
                                                icon: Icon(
                                                    Icons.comment_outlined),
                                                onPressed: null),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
///////////////////////////////////////////////////////////////////////// Service Package
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Thông tin gói dịch vụ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                wordSpacing: -1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(-1.0, 2.0),
                                      blurRadius: 6.0)
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: bookingState
                                                      .booking.serviceName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Quicksand',
                                                fontSize: 14.0),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Mô tả:  ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: bookingState.booking
                                                      .packageDescription,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Bao gồm các dịch vụ:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Column(
                                          children: bookingState
                                              .booking.services
                                              .asMap()
                                              .entries
                                              .map((MapEntry mapEntry) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                      bookingState
                                                              .booking.services[
                                                          mapEntry.key],
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Tổng cộng:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '${oCcy.format(bookingState.booking.price)} đồng',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              )),
                          SizedBox(height: 20.0),
                          formatBottomComponentBasedOnStatus(
                              bookingState.booking.status),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    );
                  }
                }
                if (bookingState is BookingStateCanceledSuccess) {
                  print('Fuck yeah I can reload it');
                  return Text('Fuck yeah I can reload it');
                }
                if (bookingState is BookingStateAcceptedSuccess) {
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateRejectedSuccess) {
                  _loadBookingDetail();
                }
                if (bookingState is BookingStateLoading) {
                  return Center(
                    child: SpinKitChasingDots(
                      duration: Duration(milliseconds: 2000),
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }

                if (bookingState is BookingStateFailure) {
                  return Text(
                    'Đã xảy ra lỗi khi tải dữ liệu',
                    style: TextStyle(color: Colors.red[300], fontSize: 16),
                  );
                }
                print('Fuck yeah I can reload it');
                return Text('Fuck yeah I can reload it');
              },
            ),
          ),
        ],
      ),
    );
  }
}
