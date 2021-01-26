import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authen_export.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:photographer_app_java_support/blocs/report_blocs/report_bloc.dart';
import 'package:photographer_app_java_support/blocs/report_blocs/reports.dart';
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/models/customer_bloc_model.dart';
import 'package:photographer_app_java_support/models/report_bloc_model.dart';
import 'package:photographer_app_java_support/models/report_template_model.dart';
import 'package:photographer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:photographer_app_java_support/models/weather_bloc_model.dart';
import 'package:photographer_app_java_support/screens/chat_screens/chat_screen.dart';
import 'package:photographer_app_java_support/screens/history_screens/location_guide.dart';
import 'package:photographer_app_java_support/services/chat_service.dart';
import 'package:photographer_app_java_support/widgets/shared/booking_detail_screen_loading.dart';
import 'package:photographer_app_java_support/widgets/shared/pop_up.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_icons/weather_icons.dart';

class BookingDetailScreen extends StatefulWidget {
  final Function(bool) onCheckIfEdited;
  final int bookingId;

  const BookingDetailScreen({this.bookingId, this.onCheckIfEdited});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  double cuLat = 0;
  double cuLong = 0;
  double destinationLat = 11.939346;
  double destinationLong = 108.445173;

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");
  final TextEditingController _reasonTextController = TextEditingController();
  final TextEditingController _reportTextController = TextEditingController();
  final TextEditingController _returningLinkController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DatabaseReference _notificationRef;
  Completer<void> _completer;

  BookingBlocModel bookingObj;

  Future<void> scanQR(String qrCode, int timeLocationId) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Huỷ", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Không thể nhận diện.';
    }
    if (!mounted) return;
    setState(() {
      if (barcodeScanRes.isEmpty || barcodeScanRes == null) {
      } else if (barcodeScanRes == qrCode) {
        _checkIn(bookingObj.id, timeLocationId);
      } else if (barcodeScanRes == 'Không thể nhận diện.') {
        _showFailAlert(
            'Thông báo', 'Không thể nhận diện.\n Xin vui lòng thử lại.');
      } else {
        _showFailAlert(
            'Cảnh báo', 'Mã QR này không hợp lệ.\n Xin vui lòng thử lại.');
      }
    });
  }

  ReportTemplateModel reportRadio = reports.last;
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  sendMessage(String myName, String userName) {
    List<String> users = [myName, userName];

    String chatRoomId = getChatRoomId(myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    ChatMethods().addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  receiverId: bookingObj.customer.id,
                  senderId: bookingObj.photographer.id,
                  avatar: bookingObj.customer.avatar,
                  chatRoomId: chatRoomId,
                  myName: myName ?? 'Thợ $globalPtgId',
                )));
  }

  Widget buildForgotToCheckIn() {
    DateTime lastestDay =
        DateTime.parse(bookingObj.listTimeAndLocations.last.start).toLocal();
    for (var item in bookingObj.listTimeAndLocations) {
      if (DateTime.parse(item.start).toLocal().isAfter(lastestDay)) {
        lastestDay = DateTime.parse(item.start);
      }
    }

    bool check = false;
    for (var i = 0; i < bookingObj.listTimeAndLocations.length; i++) {
      if (bookingObj.listTimeAndLocations[i].isCheckin) {
        check = true;
      } else {
        check = false;
      }
    }

    if (!check) {
      if (lastestDay.isBefore(DateTime.now().toLocal())) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
              onTap: () {
                _showConfirmCheckInAlert();
              },
              child: Center(
                child: Text(
                  'Gửi yêu cầu check-in toàn bộ cho khách hàng.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                ),
              )),
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  Widget buildQrCodeStatus(String inputDate, Widget qrWidget) {
    // String date =
    //     DateFormat('dd/MM/yyyy').format(DateTime.parse(inputDate).toLocal());
    // String now = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());

    DateTime dateTime = DateTime.parse(inputDate).toLocal();
    DateTime dateTimeNow = DateTime.now().toLocal();
    // if (date.compareTo(now) > 0) {
    //   return Text('Tương lai',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontStyle: FontStyle.italic,
    //         color: Colors.lightGreen[100],
    //       ));
    // } else

    if (dateTime.year < dateTimeNow.year) {
      return Text('Quá hạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red[300],
          ));
    } else if (dateTime.year == dateTimeNow.year &&
        dateTime.month < dateTimeNow.month) {
      return Text('Quá hạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red[300],
          ));
    } else if (dateTime.year == dateTimeNow.year &&
        dateTime.month == dateTimeNow.month &&
        dateTime.day < dateTimeNow.day) {
      return Text('Quá hạn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red[300],
          ));
    } else {
      return qrWidget;
    }
  }

  Widget buildQrCodeWidget(List<TimeAndLocationBlocModel> listTimeAndLocation) {
    return Column(
      children: listTimeAndLocation.asMap().entries.map((MapEntry map) {
        return Container(
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
            child: !listTimeAndLocation[map.key].isCheckin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Ngày ${DateFormat('dd/MM/yyyy').format(DateTime.parse(listTimeAndLocation[map.key].start))}',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: buildQrCodeStatus(
                            listTimeAndLocation[map.key].start,
                            InkWell(
                              onTap: () {
                                scanQR(
                                    listTimeAndLocation[map.key].qrCheckinCode,
                                    listTimeAndLocation[map.key].id);
                              },
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 30,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Ngày ${DateFormat('dd/MM/yyyy').format(DateTime.parse(listTimeAndLocation[map.key].start))}',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Đã check-in',
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ));
      }).toList(),
    );
  }

  Future<void> _reportDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: Text('Báo cáo',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Column(
                      children: reports.asMap().entries.map((MapEntry map) {
                        return Row(
                          children: [
                            Radio(
                                activeColor: Color(0xFFF77474),
                                value: reports[map.key],
                                groupValue: reportRadio,
                                onChanged: (value) {
                                  setState(() {
                                    reportRadio = value;
                                  });
                                }),
                            Text(reports[map.key].title,
                                style: TextStyle(fontSize: 14)),
                          ],
                        );
                      }).toList(),
                    ),
                    Form(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: TextFormField(
                          validator: null,
                          controller: _reportTextController,
                          cursorColor: Color(0xFFF77474),
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Chi tiết'),
                        ),
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
                  },
                ),
                FlatButton(
                  child: Text('Xác nhận'),
                  onPressed: () {
                    Navigator.pop(context);
                    _postReport();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Xin hãy nhập lý do';
                        }
                        return null;
                      },
                      controller: _reasonTextController,
                      cursorColor: Color(0xFFF77474),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Lý do hủy của bạn là gì...?'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xác nhận'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  _cancelBooking(bookingObj, _reasonTextController.text);
                }

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
        return Form(
          key: _formKey,
          child: AlertDialog(
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Xin hãy nhập lý do';
                        }
                        return null;
                      },
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
                  if (_formKey.currentState.validate()) {
                    _rejectBooking(bookingObj, _reasonTextController.text);
                    Navigator.pop(context);
                  }
                  // selectItem('Done');
                },
              ),
            ],
          ),
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
                // Navigator.pop(context);
                // selectItem('Done');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeLinkDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Lưu thay đổi',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Text('Xác nhận thay đổi',
                      style: TextStyle(
                          color: Colors.black,
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
                _moveToDoneBooking(bookingObj);
              },
            ),
          ],
        );
      },
    );
  }

  _postReport() async {
    ReportBlocModel report = ReportBlocModel(
      reason: _reportTextController.text,
      title: reportRadio.title,
      booking: bookingObj,
      photographer: bookingObj.photographer,
      createdAt: DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.now()),
    );
    BlocProvider.of<ReportBloc>(context).add(ReportEventPost(report: report));
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
    Navigator.pop(context);
    bool check = false;
    for (var i = 0; i < bookingObj.listTimeAndLocations.length; i++) {
      if (bookingObj.listTimeAndLocations[i].isCheckin) {
        check = true;
      } else {
        check = false;
        _showFailAlert('Cảnh báo',
            'Vui lòng check in gặp mặt khách hàng tất cả các ngày trước khi chuyển sang trạng thái Hậu kì');
        return;
      }
    }

    BookingBlocModel bookingTemp = BookingBlocModel(
        id: _booking.id,
        customer: CustomerBlocModel(id: _booking.customer.id),
        package: _booking.package);
    print('${bookingTemp.customer.id}');
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventMoveToEdit(booking: bookingTemp));
  }

  _moveToDoneBooking(BookingBlocModel _booking) async {
    Navigator.pop(context);
    if (_booking.returningType == 1) {
      if (_returningLinkController.text.isEmpty) {
        popUp(context, 'Nhập link trả ảnh',
            'Vui lòng nhập link trả ảnh trước khi nộp');
      } else {
        BookingBlocModel bookingTemp = BookingBlocModel(
            id: _booking.id,
            returningLink: _returningLinkController.text,
            customer: CustomerBlocModel(id: _booking.customer.id),
            package: _booking.package);
        print('${bookingTemp.customer.id}');
        BlocProvider.of<BookingBloc>(context)
            .add(BookingEventMoveToDone(booking: bookingTemp));
      }
    } else {
      BookingBlocModel bookingTemp = BookingBlocModel(
          id: _booking.id,
          customer: CustomerBlocModel(id: _booking.customer.id),
          package: _booking.package);
      print('${bookingTemp.customer.id}');
      BlocProvider.of<BookingBloc>(context)
          .add(BookingEventMoveToDone(booking: bookingTemp));
    }
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

  _checkIn(int bookingId, int timeLocationId) async {
    BlocProvider.of<BookingBloc>(context).add(BookingEventCheckIn(
        bookingId: bookingId, timeLocationId: timeLocationId));
  }

  _checkInAllRequest(int bookingId) async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventSendCheckInAllRequest(bookingId: bookingId));
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
      if (_returningLinkController.text.isEmpty) {
        _returningLinkController.text = bookingObj.returningLink;
      }
      BlocProvider.of<CommentBloc>(context)
          .add(CommentByBookingIdEventFetch(id: bookingObj.id));
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
                    bookingObj.returningType == 1
                        ? 'Giao hàng qua ứng dụng'
                        : 'Gặp mặt khách hàng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              bookingObj.returningType == 1
                  ? TextFormField(
                      controller: _returningLinkController,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return 'Xin hãy nhập link cần giao';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
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
                    )
                  : SizedBox(),
              bookingObj.returningType == 1
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          _changeLinkDialog('');
                        },
                        child: Text('Lưu thay đổi',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                      ))
                  : SizedBox()
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
        BlocBuilder<CommentBloc, CommentState>(
          builder: (BuildContext context, state) {
            if (state is CommentStateSuccess) {
              if (state.comments == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        Text('Khách hàng của bạn chưa nhận xét về lần hẹn này'),
                  ),
                );
              } else if (state.comments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        Text('Khách hàng của bạn chưa nhận xét về lần hẹn này'),
                  ),
                );
              } else {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
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
                                  backgroundImage: NetworkImage(state
                                          .comments[0].avatar ??
                                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                                  radius: 28,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SmoothStarRating(
                                              allowHalfRating: false,
                                              onRated: (v) {
                                                print('You have rate $v stars');
                                              },
                                              starCount: 5,
                                              rating: state.comments[0].rating,
                                              size: 15.0,
                                              isReadOnly: true,
                                              defaultIconData:
                                                  Icons.star_border,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              color: Colors.amber,
                                              borderColor: Colors.amber,
                                              spacing: 0.0),
                                          Text(
                                            DateFormat('dd/MM/yyyy hh:mm a')
                                                .format(DateTime.parse(state
                                                        .comments[0].createdAt)
                                                    .toLocal()),
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
                                              color: Colors.black54,
                                              fontFamily: 'Quicksand'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'bởi: ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: state
                                                        .comments[0].fullname ??
                                                    'Ẩn danh',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
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
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Quicksand'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Bình luận: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: state.comments[0].comment,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
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
              }
            }
            return Text('');
          },
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
                    bookingObj.returningType == 1
                        ? 'Giao hàng qua ứng dụng'
                        : 'Gặp mặt khách hàng',
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
                      'Từ chối',
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
                    bookingObj.returningType == 1
                        ? 'Giao hàng qua ứng dụng'
                        : 'Gặp mặt khách hàng',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
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
                'Check-in gặp mặt với khách hàng',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: -1,
                  color: Colors.black,
                ),
              ),
            ),
            buildQrCodeWidget(bookingObj.listTimeAndLocations),
            buildForgotToCheckIn(),
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
                      bookingObj.returningType == 1
                          ? 'Giao hàng qua ứng dụng'
                          : 'Gặp mặt khách hàng',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                bookingObj.returningType == 1
                    ? TextFormField(
                        controller: _returningLinkController,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return 'Xin hãy nhập link cần giao';
                          } else {
                            return null;
                          }
                        },
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
                      )
                    : SizedBox(),
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
    } else if (status.toUpperCase().trim() == 'CANCELLING_CUSTOMER') {
      text = 'Chờ hủy - Khách hàng';
      color = Colors.blueGrey;
    } else if (status.toUpperCase().trim() == 'CANCELLED_CUSTOMER') {
      text = 'Đã hủy - Khách hàng';
      color = Colors.black54;
    } else if (status.toUpperCase().trim() == 'CANCELLING_PHOTOGRAPHER') {
      text = 'Chờ hủy';
      color = Colors.blueGrey;
    } else if (status.toUpperCase().trim() == 'CANCELLED_PHOTOGRAPHER') {
      text = 'Đã hủy';
      color = Colors.black54;
    } else if (status.toUpperCase().trim() == 'EXPIRED') {
      text = 'Quá hạn';
      color = Colors.red[300];
    } else {
      text = 'Không xác định';
      color = Colors.black26;
    }

    return TextSpan(
      text: text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTimeAndLocationList(
      List<TimeAndLocationBlocModel> listTimeAndLocation) {
    return Column(
      children: listTimeAndLocation.asMap().entries.map((MapEntry mapEntry) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 1000),
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secAnimation,
                        Widget child) {
                      animation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastLinearToSlowEaseIn);
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secAnimation) {
                      return Guide(
                        currentLatitude: cuLat,
                        currentLongitude: cuLong,
                        destinationLatitude:
                            listTimeAndLocation[mapEntry.key].latitude,
                        destinationLongtitude:
                            listTimeAndLocation[mapEntry.key].longitude,
                      );
                    }));
          },
          child: Container(
            margin: EdgeInsets.all(5),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 90.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Ngày ${mapEntry.key + 1}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                            size: 15.0,
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Text(
                              listTimeAndLocation[mapEntry.key]
                                      .formattedAddress ??
                                  '',
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.timer,
                            color: Theme.of(context).primaryColor,
                            size: 15.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            DateFormat("dd/MM/yyyy hh:mm a").format(
                                DateTime.parse(
                                        listTimeAndLocation[mapEntry.key].start)
                                    .toLocal()),
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget reason(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RichText(
        text: TextSpan(
          text: '',
          style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
          children: <TextSpan>[
            TextSpan(
                text: '$title:   ',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(
                text: content, style: TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  String convertOutLookToVietnamese(String outlook) {
    String result = '';
    switch (outlook) {
      case 'freezing':
        result = 'Trời lạnh';
        break;
      case 'ice':
        result = 'Trời lạnh';
        break;
      case 'rainy':
        result = 'Trời mưa';
        break;
      case 'cloudy':
        result = 'Trời mây';
        break;
      case 'clear':
        result = 'Trời hoang';
        break;
      case 'sunny':
        result = 'Trời nắng';
        break;
    }
    return result;
  }

  Widget _buildWeatherNotice(
      WeatherBlocModel notice, int noticeIndex, int length) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                BoxedIcon(WeatherIcons.day_cloudy),
                Text('${convertOutLookToVietnamese(notice.outlook)}')
              ],
            ),
            Column(
              children: [
                BoxedIcon(WeatherIcons.thermometer),
                Text('${notice.temperature.round()} °C')
              ],
            ),
            Column(
              children: [
                BoxedIcon(WeatherIcons.humidity),
                Text('${notice.humidity.round()} %')
              ],
            ),
            Column(
              children: [
                BoxedIcon(WeatherIcons.wind),
                Text('${notice.windSpeed.roundToDouble()} m/s')
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text('${notice.noti}'),
        SizedBox(
          height: 10,
        ),
        (noticeIndex + 1) == length
            ? SizedBox()
            : Divider(
                height: 10,
              ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildNotice() {
    if ((bookingObj.weatherWarnings.isNotEmpty ||
            bookingObj.locationWarnings.isNotEmpty ||
            bookingObj.timeWarnings.isNotEmpty ||
            bookingObj.selfWarnDistance.isNotEmpty) &&
        ((bookingObj.status.toUpperCase() != 'DONE') &&
            (bookingObj.status.toUpperCase() != 'EDITING') &&
            (bookingObj.status.toUpperCase() != 'CANCELED') &&
            (bookingObj.status.toUpperCase() != 'REJECTED'))) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.black26,
            endIndent: 15,
            indent: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Chú ý:',
            style: TextStyle(
                color: Colors.red[300],
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          bookingObj.weatherWarnings.isNotEmpty
              ? Column(
                  children: bookingObj.listWeatherNoticeDetails
                      .asMap()
                      .entries
                      .map((MapEntry map) {
                    return _buildWeatherNotice(
                        bookingObj.listWeatherNoticeDetails[map.key],
                        map.key,
                        bookingObj.listWeatherNoticeDetails.length);
                  }).toList(),
                )
              : SizedBox(),
          bookingObj.locationWarnings.isNotEmpty
              ? Column(
                  children: bookingObj.locationWarnings
                      .asMap()
                      .entries
                      .map((MapEntry map) {
                    String locationWarning = '';
                    var distanceAndName = [];
                    if (bookingObj.locationWarnings.isNotEmpty) {
                      locationWarning =
                          bookingObj.locationWarnings[map.key].toString();
                      distanceAndName = locationWarning.split(',');
                    }

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              size: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: RichText(
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Quicksand'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'Địa điểm của lịch hẹn này với khách hàng ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text: distanceAndName[0],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' là ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                  TextSpan(
                                      text: '${distanceAndName[1]} km',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: '!',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }).toList(),
                )
              : SizedBox(),
          bookingObj.timeWarnings.isNotEmpty
              ? Column(
                  children: bookingObj.timeWarnings
                      .asMap()
                      .entries
                      .map((MapEntry map) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.alarm_off,
                              size: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(
                              bookingObj.timeWarnings[map.key].toString(),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }).toList(),
                )
              : SizedBox(),
          bookingObj.selfWarnDistance.isNotEmpty
              ? Column(
                  children: bookingObj.selfWarnDistance
                      .asMap()
                      .entries
                      .map((MapEntry map) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.wrong_location_outlined,
                              size: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(
                              bookingObj.selfWarnDistance[map.key].toString(),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }).toList(),
                )
              : SizedBox(),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildTimeAndLocationInfoMultiDay(BookingBlocModel bookingBlocModel) {
    return Container(
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
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Trạng thái:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      statusFormat(bookingBlocModel.status),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Thời gian tác nghiệp dự kiến/1 ngày:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: bookingObj.timeAnticipate == null
                              ? '3 giờ'
                              : '${(bookingObj.timeAnticipate / 3600).round()} giờ',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Thời gian nhận ảnh:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: DateFormat('dd/MM/yyyy hh:mm a').format(
                              DateTime.parse(bookingBlocModel.editDeadLine)
                                  .toLocal()),
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                _buildCanceledReason(),
                SizedBox(
                  height: 10,
                ),
                Text('Địa điểm và thời gian cụ thể:   ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                _buildTimeAndLocationList(
                    bookingBlocModel.listTimeAndLocations),
                SizedBox(
                  height: 10,
                ),
                _buildNotice(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAndLocationInfoSingleDay(BookingBlocModel bookingBlocModel) {
    return Container(
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
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Trạng thái:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      statusFormat(bookingBlocModel.status),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Thời gian chụp:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      bookingBlocModel.listTimeAndLocations.isNotEmpty
                          ? TextSpan(
                              text: DateFormat('dd/MM/yyyy hh:mm a').format(
                                  DateTime.parse(bookingBlocModel
                                          .listTimeAndLocations[0].start)
                                      .toLocal()),
                              style: TextStyle(fontWeight: FontWeight.normal))
                          : bookingBlocModel.startDate == null
                              ? TextSpan(text: '')
                              : TextSpan(
                                  text: DateFormat('dd/MM/yyyy hh:mm a').format(
                                      DateTime.parse(bookingBlocModel.startDate)
                                          .toLocal()),
                                ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Thời gian tác nghiệp dự kiến:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: bookingObj.timeAnticipate == null
                              ? '3 giờ'
                              : '${(bookingObj.timeAnticipate / 3600).round()} giờ',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Thời gian nhận ảnh:   ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      bookingBlocModel.listTimeAndLocations.isNotEmpty
                          ? TextSpan(
                              text: DateFormat('dd/MM/yyyy hh:mm a').format(
                                  DateTime.parse(bookingBlocModel.editDeadLine)
                                      .toLocal()),
                              style: TextStyle(fontWeight: FontWeight.normal))
                          : bookingBlocModel.endDate == null
                              ? TextSpan(text: '')
                              : TextSpan(
                                  text: DateFormat('dd/MM/yyyy hh:mm a').format(
                                      DateTime.parse(
                                              bookingBlocModel.editDeadLine)
                                          .toLocal()),
                                ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Quicksand'),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Địa điểm:  ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            bookingBlocModel.listTimeAndLocations.isNotEmpty
                                ? TextSpan(
                                    text: bookingBlocModel
                                        .listTimeAndLocations[0]
                                        .formattedAddress,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal))
                                : bookingBlocModel.location == null
                                    ? TextSpan(text: '')
                                    : TextSpan(text: bookingBlocModel.location),
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
                                    currentLatitude: cuLat,
                                    currentLongitude: cuLong,
                                    destinationLatitude: bookingBlocModel
                                        .listTimeAndLocations[0].latitude,
                                    destinationLongtitude: bookingBlocModel
                                        .listTimeAndLocations[0].longitude,
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
                _buildCanceledReason(),
                SizedBox(
                  height: 10,
                ),
                _buildNotice(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanceledReason() {
    print(bookingObj.customerCanceledReason.isNotEmpty);
    print(bookingObj.photographerCanceledReason.isNotEmpty);
    print(bookingObj.rejectedReason.isNotEmpty);
    if (bookingObj.status.toUpperCase().contains('CANCELLED') ||
        bookingObj.status.toUpperCase().contains('CANCELLING')) {
      if (bookingObj.customerCanceledReason.isNotEmpty) {
        return reason(
            'Lý do hủy của khách hàng', bookingObj.customerCanceledReason);
      } else if (bookingObj.photographerCanceledReason.isNotEmpty) {
        return reason(
            'Lý do hủy của bạn', bookingObj.photographerCanceledReason);
      }
    } else if (bookingObj.status.toUpperCase() == 'REJECTED') {
      if (bookingObj.rejectedReason.isNotEmpty) {
        return reason('Lý do từ chối của bạn', bookingObj.rejectedReason);
      }
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    _notificationRef = FirebaseDatabase.instance
        .reference()
        .child('Notification_$globalPtgId');
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
        actions: [
          PopupMenuButton<int>(
            icon: Icon(
              Icons.sort,
              color: Colors.black87,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _reportDialog();
                    },
                    icon: Icon(Icons.outlined_flag_rounded),
                    label: Text('Báo cáo')),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: StreamBuilder(
          stream: _notificationRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data.snapshot.value != null) {
              _loadBookingDetail();
            }
            return BlocListener<ReportBloc, ReportState>(
              listener: (context, state) {
                if (state is ReportStateLoading) {
                  _showLoadingAlert();
                }
                if (state is ReportStatePostedSuccess) {
                  Navigator.pop(context);
                  if (state.isPosted) {
                    _reportTextController.clear();
                    popUp(context, 'Báo cáo', 'Gửi báo cáo thành công!');
                  }
                }
                if (state is ReportStateFailure) {
                  Navigator.pop(context);
                  String error = state.error.replaceAll('Exception: ', '');
                  if (error.toUpperCase() == 'UNAUTHORIZED') {
                    _showUnauthorizedDialog();
                  } else {
                    popUp(context, 'Báo cáo', 'Gửi báo cáo thất bại!');
                  }
                }
              },
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Center(
                    child: BlocConsumer<BookingBloc, BookingState>(
                      listener: (context, state) {
                        if (state is BookingStateFailure) {
                          String error =
                              state.error.replaceAll('Exception: ', '');
                          if (error.toUpperCase() == 'UNAUTHORIZED') {
                            _showUnauthorizedDialog();
                          } else {
                            _showFailAlert('Thất bại',
                                'Đã có lỗi xảy ra trong lúc gửi yêu cầu!');
                          }
                        }

                        if (state is BookingStateCheckInAllRequestLoading) {
                          _showLoadingAlert();
                        }

                        if (state is BookingStateCheckInAllRequestSuccess) {
                          Navigator.pop(context);
                          _loadBookingDetail();
                          _showSuccessAlert();
                        }

                        if (state is BookingStateCheckInAllRequestFailure) {
                          Navigator.pop(context);
                          String error =
                              state.error.replaceAll('Exception: ', '');
                          if (error.toUpperCase() == 'UNAUTHORIZED') {
                            _showUnauthorizedDialog();
                          } else {
                            _showFailAlert('Thất bại',
                                'Đã có lỗi xảy ra trong lúc gửi yêu cầu!');
                          }
                        }

                        if (state is BookingStateCheckInSuccess) {
                          _loadBookingDetail();
                        }
                      },
                      builder: (context, bookingState) {
                        if (bookingState is BookingDetailStateSuccess) {
                          bookingObj = bookingState.booking;
                          if (bookingState.booking == null) {
                            return Text(
                              'Không lấy được dữ liệu của cuộc hẹn',
                              style: TextStyle(
                                color: Colors.redAccent,
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
                                  ///////////////////////////////////info

                                  bookingState.booking.isMultiday
                                      ? _buildTimeAndLocationInfoMultiDay(
                                          bookingState.booking)
                                      : _buildTimeAndLocationInfoSingleDay(
                                          bookingState.booking),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ///////////////////////////////////////////////////////////////////////// Photographer
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 0.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        bookingState
                                                                .booking
                                                                .customer
                                                                .avatar ??
                                                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                                      ),
                                                      radius: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                        bookingState
                                                                .booking
                                                                .customer
                                                                .fullname ??
                                                            'Ẩn danh',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                      onPressed: () => launch(
                                                          'tel://${bookingState.booking.customer.phone}'),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .comment_outlined),
                                                      onPressed: () {
                                                        // ignore: unrelated_type_equality_checks
                                                        if (ChatMethods()
                                                                .checkChatRoomExist(
                                                                    '${bookingState.booking.customer.fullname}_${bookingState.booking.photographer.fullname}') ==
                                                            true) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ChatPage(
                                                                            receiverId:
                                                                                bookingObj.customer.id,
                                                                            senderId:
                                                                                bookingObj.photographer.id,
                                                                            avatar:
                                                                                bookingObj.customer.avatar,
                                                                            chatRoomId:
                                                                                "${bookingState.booking.customer.fullname}_${bookingState.booking.photographer.fullname}",
                                                                            myName:
                                                                                bookingState.booking.photographer.fullname ?? 'Thợ ',
                                                                          )));
                                                        } else {
                                                          sendMessage(
                                                              '${bookingState.booking.photographer.fullname}',
                                                              '${bookingState.booking.customer.fullname}');
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: bookingState
                                                              .booking
                                                              .serviceName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: bookingState
                                                              .booking
                                                              .packageDescription,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Bao gồm các dịch vụ:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5.0,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.done,
                                                            color: Color(
                                                                0xFFF77474),
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              bookingState
                                                                      .booking
                                                                      .services[
                                                                  mapEntry.key],
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Tổng cộng:',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      '${oCcy.format(bookingState.booking.price)} đồng',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }
                        if (bookingState is BookingStateAcceptedSuccess) {
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }

                        if (bookingState is BookingStateRejectedSuccess) {
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }

                        if (bookingState is BookingStateCanceledSuccess) {
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }

                        if (bookingState is BookingStateMovedToEditSuccess) {
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }

                        if (bookingState is BookingStateMovedToDoneSuccess) {
                          if (widget.onCheckIfEdited != null) {
                            widget.onCheckIfEdited(true);
                          }
                          _loadBookingDetail();
                        }

                        if (bookingState is BookingStateLoading) {
                          return BookingDetailLoading();
                        }

                        if (bookingState is BookingStateFailure) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Đã xảy ra lỗi khi tải dữ liệu',
                                    style: TextStyle(
                                        color: Colors.red[300], fontSize: 16),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _loadBookingDetail();
                                    },
                                    child: Text(
                                      'Ấn để thử lại',
                                      style: TextStyle(
                                          color: Colors.red[300], fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> _showUnauthorizedDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Thông báo',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Tài khoản không có quyền truy cập nội dung này!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }

  Future<void> _showFailAlert(String title, String content) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/fail.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                title,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }

  Future<void> _showConfirmCheckInAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/question.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Xác nhận',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Xác nhận gửi yêu cầu check-in toàn bộ cho khách hàng?',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
                _checkInAllRequest(bookingObj.id);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: Theme.of(context).scaffoldBackgroundColor,
              buttonCancelText: Text(
                'Hủy bỏ',
                style: TextStyle(color: Colors.black87),
              ),
            ));
  }

  Future<void> _showLoadingAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) {
          return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Material(
                type: MaterialType.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
                child: Image.asset(
                  'assets/images/loading_2.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  Future<void> _showSuccessAlert() async {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        useRootNavigator: false,
        builder: (BuildContext aContext) => AssetGiffyDialog(
              image: Image.asset(
                'assets/images/done_booking.gif',
                fit: BoxFit.cover,
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              title: Text(
                'Hoàn thành',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                'Gửi yêu cầu thành công!!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.pop(context);
              },
              buttonOkColor: Theme.of(context).primaryColor,
              buttonOkText: Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
