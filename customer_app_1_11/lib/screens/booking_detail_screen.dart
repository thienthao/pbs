import 'dart:async';

import 'package:customer_app_1_11/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_1_11/models/booking_bloc_model.dart';
import 'package:customer_app_1_11/models/photographer_bloc_model.dart';
import 'package:customer_app_1_11/respositories/booking_repository.dart';
import 'package:customer_app_1_11/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:http/http.dart' as http;
import 'package:status_alert/status_alert.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailScreen({this.bookingId});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  Completer<void> _completer;

  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  BookingBloc _bookingBloc;
  BookingBlocModel bookingObj;
  bool isAbleToCanceled = true;
  bool isCanceled = false;
  final TextEditingController _reasonTextController = TextEditingController();

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
      text = 'Bị từ chối';
      color = Colors.redAccent;
    } else if (status.toUpperCase().trim() == 'ONGOING') {
      text = 'Sắp diễn ra';
      color = Colors.blueAccent;
    } else if (status.toUpperCase().trim() == 'EDITING') {
      text = 'Đang hậu kì';
      color = Colors.cyan;
    } else if (status.toUpperCase().trim() == 'CANCELED') {
      text = 'Đã hủy';
      color = Colors.black;
    }

    return TextSpan(
      text: text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget formatBottomComponentBasedOnStatus(String status) {
    if (status.toUpperCase().trim() == 'DONE') {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        ),
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Color(0xFFF77474),
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Giao hàng qua ứng dụng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'https://drive.google.com/',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Nhận xét của tôi',
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
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/girl.jpg'),
                    radius: 28,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  print('You have rate $v stars');
                                },
                                starCount: 5,
                                rating: 4.0,
                                size: 15.0,
                                isReadOnly: true,
                                defaultIconData: Icons.star_border,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                color: Colors.amber,
                                borderColor: Colors.amber,
                                spacing: 0.0),
                            Text(
                              '18/10/2020',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                                color: Colors.black54, fontFamily: 'Quicksand'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'bởi: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'Uyển Nhi',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(
                                color: Colors.black54, fontFamily: 'Quicksand'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Địa điểm: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'Hồ Chí Minh',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              RichText(
                text: TextSpan(
                  text: '',
                  style:
                      TextStyle(color: Colors.black54, fontFamily: 'Quicksand'),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Bình luận: ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Anh nhiệt tình, có góc nghệ thuật đẹp, em sẽ đặt nữa nếu có nhu cầu ^^',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]);
    } else if (status.toUpperCase().trim() == 'PENDING') {
      return Container(
        child: Column(
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
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Color(0xFFF77474),
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Giao hàng qua ứng dụng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                      color: Color(0xFFF77474),
                      onPressed: () {
                        _showMyDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Hủy',
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      );
    } else if (status.toUpperCase().trim() == 'REJECTED') {
    } else if (status.toUpperCase().trim() == 'ONGOING') {
      return Container(
        child: Column(
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
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Color(0xFFF77474),
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Giao hàng qua ứng dụng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                      color: Color(0xFFF77474),
                      onPressed: () {
                        _showMyDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Hủy',
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      );
    } else if (status.toUpperCase().trim() == 'CANCELED') {
    } else if (status.toUpperCase().trim() == 'EDITING') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
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
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Icon(
                      Icons.done,
                      color: Color(0xFFF77474),
                      size: 20,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Giao hàng qua ứng dụng',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ButtonTheme(
                  minWidth: 300.0,
                  child: RaisedButton(
                    color: Color(0xFFF77474),
                    onPressed: () {
                      _showMyDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Hủy',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ),
                )),
          )
        ],
      );
    }
    return Text('');
  }

  Widget displayCancelReasonBasedOnStatus(String status) {
    if (status.toUpperCase().trim() == 'CANCELED') {
      if (bookingObj.customerCanceledReason == null &&
          bookingObj.photographerCanceledReason != null) {
        return RichText(
          text: TextSpan(
            text: '',
            style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Lý do hủy của photographer:   ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: bookingObj.photographerCanceledReason,
                  style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        );
      } else if (bookingObj.customerCanceledReason != null &&
          bookingObj.photographerCanceledReason == null) {
        return RichText(
          text: TextSpan(
            text: '',
            style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Lý do hủy của tôi:   ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: bookingObj.customerCanceledReason,
                  style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        );
      }
    }
    return SizedBox(height: 0,);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Hủy cuộc hẹn',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: TextFormField(
                    controller: _reasonTextController,
                    cursorColor: Color(0xFFF77474),
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Lý do hủy của bạn là gì...'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                print(
                    '${bookingObj.id} ${bookingObj.photographer.id}, ${bookingObj.package.id}');
                BookingBlocModel booking = BookingBlocModel(
                    id: bookingObj.id,
                    customerCanceledReason: _reasonTextController.text,
                    photographer: Photographer(id: bookingObj.photographer.id),
                    package: bookingObj.package);
                _bookingBloc.add(BookingEventCancel(booking: booking));
                Navigator.pop(context);

                _loadBookingDetail();
                selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  void selectItem(String name) async {
    isAbleToCanceled = false;

    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Đã hủy hoạt động này',
      configuration: IconConfiguration(
        icon: Icons.done,
      ),
    );
  }

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _bookingBloc = BookingBloc(bookingRepository: _bookingRepository);
    _loadBookingDetail();
  }

  _loadBookingDetail() async {
    context
        .bloc<BookingBloc>()
        .add(BookingEventDetailFetch(id: widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Thông tin hoạt động',
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
                                                text: 'Thời gian chụp:   ',
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
                                                text: 'Thời gian nhận ảnh:   ',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                      displayCancelReasonBasedOnStatus(
                                          bookingState.booking.status),
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
///////////////////////////////////////////////////////////////////////// Photographer
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Thông tin photographer',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                wordSpacing: -1,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Theme.of(context).primaryColor,
                          //     borderRadius: BorderRadius.circular(30.0),
                          //   ),
                          //   margin: const EdgeInsets.only(left: 5.0, right: 300.0),
                          //   height: 3.0,
                          // ),
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
                                                  bookingState.booking
                                                      .photographer.avatar),
                                              radius: 30,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    bookingState.booking
                                                        .photographer.fullname,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      '4.5',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SmoothStarRating(
                                                        allowHalfRating: false,
                                                        onRated: (v) {
                                                          print(
                                                              'You have rate $v stars');
                                                        },
                                                        starCount: 5,
                                                        rating: 4.5,
                                                        size: 15.0,
                                                        isReadOnly: true,
                                                        defaultIconData:
                                                            Icons.star_border,
                                                        filledIconData:
                                                            Icons.star,
                                                        halfFilledIconData:
                                                            Icons.star_half,
                                                        color: Colors.amber,
                                                        borderColor:
                                                            Colors.amber,
                                                        spacing: 0.0),
                                                  ],
                                                ),
                                              ],
                                            ),
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

                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Theme.of(context).primaryColor,
                          //     borderRadius: BorderRadius.circular(30.0),
                          //   ),
                          //   margin: const EdgeInsets.only(left: 5.0, right: 300.0),
                          //   height: 3.0,
                          // ),
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
                          formatBottomComponentBasedOnStatus(bookingObj.status),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }
                }
                if (bookingState is BookingStateCanceledSuccess) {
                  _loadBookingDetail();
                }
                if (bookingState is BookingStateLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Loading(),
                  );
                }

                if (bookingState is BookingStateFailure) {
                  return Text(
                    'Đã xảy ra lỗi khi tải dữ liệu',
                    style: TextStyle(color: Colors.red[300], fontSize: 16),
                  );
                }
                return Text('');
              },
            ),
          ),
        ],
      ),
    );
  }
}
