import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/constant/chat_name.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/models/customer_bloc_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photographer_app_java_support/screens/chat_screens/chat_screen.dart';
import 'package:photographer_app_java_support/screens/history_screens/location_guide.dart';
import 'package:photographer_app_java_support/services/chat_service.dart';
import 'package:photographer_app_java_support/widgets/shared/loading_line.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends StatefulWidget {
  final Function(bool) onCheckIfEdited;
  final int bookingId;

  const BookingDetailScreen({this.bookingId, this.onCheckIfEdited});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    ChatMethods().addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  chatRoomId: chatRoomId,
                )));
  }

  double cuLat = 0;
  double cuLong = 0;
  double destinationLat = 11.939346;
  double destinationLong = 108.445173;

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  final TextEditingController _reasonTextController = TextEditingController();
  Completer<void> _completer;

  BookingBlocModel bookingObj;

  Future<void> _cancelDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Hủy hoạt động',
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
                        hintText: 'Lý do hủy của bạn là gì...?'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                _cancelBooking(bookingObj, _reasonTextController.text);
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _rejectDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Từ chối hoạt động',
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
                        hintText: 'Lý do từ chối của bạn là gì...?'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                _rejectBooking(bookingObj, _reasonTextController.text);
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _moveToStatusDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Chuyển sang $title',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('Xác nhận chuyển sang $title',
                      style: TextStyle(
                          color: title.toUpperCase().trim() == 'HẬU KÌ'
                              ? Colors.cyan
                              : Colors.lightGreen[400],
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                if (title.toUpperCase().trim() == 'HẬU KÌ') {
                  _moveToEditBooking(bookingObj);
                } else {
                  _moveToDoneBooking(bookingObj);
                }
                Navigator.pop(context);
                // selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  _loadBookingDetail() async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventDetailFetch(id: widget.bookingId));
  }

  _acceptBooking(BookingBlocModel _booking) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventAccept(booking: bookingTemp));
  }

  _moveToEditBooking(BookingBlocModel _booking) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventMoveToEdit(booking: bookingTemp));
  }

  _moveToDoneBooking(BookingBlocModel _booking) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventMoveToDone(booking: bookingTemp));
  }

  _rejectBooking(BookingBlocModel _booking, String _rejectReason) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        rejectedReason: _rejectReason,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventReject(booking: bookingTemp));
  }

  _cancelBooking(BookingBlocModel _booking, String _cancelReason) async {
    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        photographerCanceledReason: _cancelReason,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventCancel(booking: bookingTemp));
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      cuLat = position.latitude;
      cuLong = position.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBookingDetail();
    getCurrentLocation();
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
            'Nhận xét của khách hàng',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  minWidth: 150.0,
                  height: 60.0,
                  color: Colors.white,
                  onPressed: () {
                    _rejectDialog();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  minWidth: 150.0,
                  height: 60.0,
                  color: Colors.white,
                  onPressed: () {
                    _cancelDialog();
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
                  buttonColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minWidth: 180.0,
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      _moveToStatusDialog('Hậu kì');
                      // Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Hậu kì',
                        style: TextStyle(fontSize: 21.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (status.toUpperCase().trim() == 'CANCELED') {
    } else if (status.toUpperCase().trim() == 'EDITING') {
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
                TextField(
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
                  _cancelDialog();
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
                    _moveToStatusDialog('Hoàn thành');
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
    return Text('');
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
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Guide(
                                                          currentLatitude:
                                                              cuLat,
                                                          currentLongitude:
                                                              cuLong,
                                                          destinationLatitude:
                                                              destinationLat,
                                                          destinationLongtitude:
                                                              destinationLong,
                                                        )),
                                              );
                                            },
                                            child: Icon(
                                              Icons.location_pin,
                                              size: 30,
                                              color: Colors.grey,
                                            ),
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
                                              icon: Icon(
                                                  Icons.phone_android_outlined),
                                              onPressed: () => launch(
                                                  'tel://${bookingState.booking.customer.phone}'),
                                            ),
                                            IconButton(
                                              icon:
                                                  Icon(Icons.comment_outlined),
                                              onPressed: () {
                                                if (ChatMethods()
                                                        .checkChatRoomExist(
                                                            'Uyển Nhi_Cao Tiến') ==
                                                    true) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                chatRoomId:
                                                                    "Uyển Nhi_Cao Tiến",
                                                              )));
                                                } else {
                                                  sendMessage('Uyển Nhi');
                                                }
                                              },
                                            ),
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
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }
                if (bookingState is BookingStateAcceptedSuccess) {
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateRejectedSuccess) {
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateCanceledSuccess) {
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateMovedToEditSuccess) {
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateMovedToDoneSuccess) {
                  widget.onCheckIfEdited(true);
                  _loadBookingDetail();
                }

                if (bookingState is BookingStateLoading) {
                  // return Center(
                  //   child: SpinKitChasingDots(
                  //     duration: Duration(milliseconds: 2000),
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // );
                  return LoadingLine();
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
