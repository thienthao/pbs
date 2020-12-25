import 'dart:async';

import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/package_blocs/package_bloc.dart';
import 'package:customer_app_java_support/blocs/package_blocs/packages.dart';
import 'package:customer_app_java_support/blocs/warning_blocs/warnings.dart';
import 'package:customer_app_java_support/constant/chat_name.dart';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:customer_app_java_support/respositories/package_repository.dart';
import 'package:customer_app_java_support/respositories/warning_repository.dart';
import 'package:customer_app_java_support/screens/chat_screens/chat_screen.dart';
import 'package:customer_app_java_support/shared/booking_detail_screen_loading.dart';
import 'package:customer_app_java_support/screens/history_screens/booking_many_day_edit_screen.dart';
import 'package:customer_app_java_support/screens/history_screens/booking_one_day_edit_screen.dart';
import 'package:customer_app_java_support/screens/history_screens/location_guide.dart';
import 'package:customer_app_java_support/screens/rating_screen/rating_screen.dart';
import 'package:customer_app_java_support/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;
  final Function(bool) isEdited;

  const BookingDetailScreen({this.bookingId, this.isEdited});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  double cuLat = 0;
  double cuLong = 0;
  double destinationLat = 11.939346;
  double destinationLong = 108.445173;
  Completer<void> _completer;
  final _formKey = GlobalKey<FormState>();

  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  BookingBlocModel bookingObj;
  bool isAbleToCanceled = true;
  bool isCanceled = false;
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
  PackageRepository _packageRepository =
      PackageRepository(httpClient: http.Client());
  WarningRepository _warningRepository =
      WarningRepository(httpClient: http.Client());
  final TextEditingController _reasonTextController = TextEditingController();

  bool isBookingEdited = false;

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
              avatar: bookingObj.photographer.avatar,
                  chatRoomId: chatRoomId,
                )));
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
      BlocProvider.of<CommentBloc>(context)
          .add(CommentByBookingIdEventFetch(id: bookingObj.id));
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
                          : 'Gặp mặt photographer',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                bookingObj.returningType == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            launch(bookingObj.returningLink == 'drive' ? 'http://drive.google.com': bookingObj.returningLink);
                          },
                          child: Text(
                            bookingObj.returningLink ?? '',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<CommentBloc, CommentState>(
            builder: (BuildContext context, state) {
              if (state is CommentStateSuccess) {
                if (state.comments == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
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
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 1000),
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
                                      return BlocProvider(
                                        create: (context) => CommentBloc(
                                            commentRepository:
                                                _commentRepository),
                                        child: RatingScreen(
                                          bookingId: bookingObj.id,
                                          onRatingSuccess:
                                              (bool ratingSuccess) {
                                            if (ratingSuccess) {
                                              _loadBookingDetail();
                                            }
                                          },
                                        ),
                                      );
                                    }));
                          },
                          child: Text(
                            'Nhận xét',
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state.comments.isEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
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
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 1000),
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
                                      return BlocProvider(
                                        create: (context) => CommentBloc(
                                            commentRepository:
                                                _commentRepository),
                                        child: RatingScreen(
                                          bookingId: bookingObj.id,
                                          onRatingSuccess:
                                              (bool ratingSuccess) {
                                            if (ratingSuccess) {
                                              _loadBookingDetail();
                                            }
                                          },
                                        ),
                                      );
                                    }));
                          },
                          child: Text(
                            'Nhận xét',
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                    backgroundImage: NetworkImage(state
                                            .comments[0].avatar ??
                                        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                                    radius: 28,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.68,
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
                                                  print(
                                                      'You have rate $v stars');
                                                },
                                                starCount: 5,
                                                rating:
                                                    state.comments[0].rating,
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
                                                          .comments[0]
                                                          .createdAt)
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
                                                      .comments[0].fullname,
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
        ],
      );
    } else if (status.toUpperCase().trim() == 'PENDING') {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                bookingObj.returningType == 1
                    ? 'Giao hàng qua ứng dụng'
                    : 'Gặp mặt photographer',
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
                        : 'Gặp mặt photographer',
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
                    _showMyDialog();
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
                                return !bookingObj.isMultiday
                                    ? MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => BookingBloc(
                                                bookingRepository:
                                                    _bookingRepository),
                                          ),
                                          BlocProvider(
                                            create: (context) => WarningBloc(
                                                warningRepository:
                                                    _warningRepository),
                                          ),
                                          BlocProvider(
                                              create: (BuildContext context) =>
                                                  PackageBloc(
                                                      packageRepository:
                                                          _packageRepository)
                                                    ..add(
                                                        PackageByPhotographerIdEventFetch(
                                                            id: bookingObj
                                                                .photographer
                                                                .id)))
                                        ],
                                        child: BookingOneDayEditScreen(
                                          isEdited: (bool isEdited) {
                                            print('on BKDET $isEdited');
                                            if (isEdited) {
                                              widget.isEdited(true);
                                              _loadBookingDetail();
                                            }
                                          },
                                          bookingBlocModel: bookingObj,
                                          selectedPackage: bookingObj.package,
                                          photographer: bookingObj.photographer,
                                        ),
                                      )
                                    : MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => BookingBloc(
                                                bookingRepository:
                                                    _bookingRepository),
                                          ),
                                          BlocProvider(
                                            create: (context) => PackageBloc(
                                                packageRepository:
                                                    _packageRepository)
                                              ..add(
                                                  PackageByPhotographerIdEventFetch(
                                                      id: bookingObj
                                                          .photographer.id)),
                                          ),
                                        ],
                                        child: BookingManyDayEdit(
                                          bookingBlocModel: bookingObj,
                                          selectedPackage: bookingObj.package,
                                          photographer: bookingObj.photographer,
                                          isEdited: (bool isEdited) {
                                            if (isEdited) {
                                              widget.isEdited(true);
                                              _loadBookingDetail();
                                            }
                                          },
                                        ),
                                      );
                              }));

                      // _acceptBooking(bookingObj);
                      // Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sửa',
                        style: TextStyle(
                            fontSize: 21.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
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
                        : 'Gặp mặt photographer',
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
                      bookingObj.returningType == 1
                          ? 'Giao hàng qua ứng dụng'
                          : 'Gặp mặt photographer',
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

  Widget reason(String title, String content) {
    return RichText(
      text: TextSpan(
        text: '',
        style: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
        children: <TextSpan>[
          TextSpan(
              text: '$title:   ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          TextSpan(
              text: content, style: TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Hủy cuộc hẹn',
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
                          hintText: 'Lý do hủy của bạn là gì...'),
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
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  BookingBlocModel booking = BookingBlocModel(
                      id: bookingObj.id,
                      customerCanceledReason: _reasonTextController.text,
                      photographer:
                          Photographer(id: bookingObj.photographer.id),
                      package: bookingObj.package);
                  BlocProvider.of<BookingBloc>(context).add(
                      BookingEventCancel(booking: booking, cusId: globalCusId));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void testDialog(String name) async {
    return showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext aContext) {
        return AlertDialog(
          title: Text('Hủy cuộc hẹn $name',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  NumberFormat oCcy = NumberFormat("#,##0", "vi_VN");

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    cuLat = position.latitude;
    cuLong = position.longitude;
    print('cuLat + cuLat');
  }

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadBookingDetail();
    getCurrentLocation();
  }

  _loadBookingDetail() async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventDetailFetch(id: widget.bookingId));
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
                                  .formattedAddress,
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
                SizedBox(
                  height: 10,
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
                          : SizedBox()
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
                                      DateTime.parse(bookingBlocModel.endDate)
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
                                : bookingBlocModel.address == null
                                    ? TextSpan(text: '')
                                    : TextSpan(text: bookingBlocModel.address),
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
    if (bookingObj.status.toUpperCase() == 'CANCELED') {
      if (bookingObj.customerCanceledReason.isNotEmpty) {
        return reason('Lý do hủy của bạn', bookingObj.customerCanceledReason);
      } else if (bookingObj.photographerCanceledReason.isNotEmpty) {
        return reason('Lý do hủy của photographer',
            bookingObj.photographerCanceledReason);
      }
    } else if (bookingObj.status.toUpperCase() == 'REJECTED') {
      if (bookingObj.rejectedReason.isNotEmpty) {
        return reason(
            'Lý do từ chối của photographer', bookingObj.rejectedReason);
      }
    }
    return SizedBox();
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
        padding: EdgeInsets.zero,
        children: <Widget>[
          Center(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, bookingState) {
                if (bookingState is BookingDetailStateSuccess) {
                  widget.isEdited(true);
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
                              'Thông tin photographer',
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
                                                          .booking
                                                          .photographer
                                                          .avatar ??
                                                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
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
                                                      '${bookingState.booking.photographer.ratingCount ?? 0.0}',
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
                                                        rating: bookingState
                                                                .booking
                                                                .photographer
                                                                .ratingCount ??
                                                            0.0,
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
                                                onPressed: () {
                                                  launch(
                                                      'tel://${bookingState.booking.photographer.phone}');
                                                }),
                                            IconButton(
                                              icon:
                                                  Icon(Icons.comment_outlined),
                                              onPressed: () {
                                                // ignore: unrelated_type_equality_checks
                                                if (ChatMethods()
                                                        .checkChatRoomExist(
                                                            '${bookingState.booking.customer.fullname}_${bookingState.booking.photographer.fullname}') ==
                                                    true) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                avatar: bookingObj.photographer.avatar,
                                                                chatRoomId:
                                                                    "${bookingState.booking.customer.fullname}_${bookingState.booking.photographer.fullname}",
                                                              )));
                                                } else {
                                                  sendMessage('${bookingState.booking.photographer.fullname}');
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
                          SizedBox(
                            height: 20,
                          ),
                          formatBottomComponentBasedOnStatus(bookingObj.status),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    );
                  }
                }

                if (bookingState is BookingStateCancelInProgress) {
                  return BookingDetailLoading();
                }
                if (bookingState is BookingStateCanceledSuccess) {
                  _loadBookingDetail();
                }
                if (bookingState is BookingStateLoading) {
                  return BookingDetailLoading();
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
