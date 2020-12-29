import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/booking_repository.dart';
import 'package:photographer_app_java_support/respositories/comment_repository.dart';
import 'package:photographer_app_java_support/screens/history_screens/booking_detail_screen.dart';

class UpComSlidable extends StatefulWidget {
  final List<BookingBlocModel> blocPendingBookings;
  final Function(bool) isEdited;
  const UpComSlidable({this.blocPendingBookings, this.isEdited});
  @override
  _UpComSlidableState createState() => _UpComSlidableState();
}

class _UpComSlidableState extends State<UpComSlidable> {
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());

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
      text = 'Bị từ chối';
      color = Colors.redAccent;
    } else if (status.toUpperCase().trim() == 'ONGOING') {
      text = 'Sắp diễn ra';
      color = Colors.blueAccent;
    } else if (status.toUpperCase().trim() == 'CANCELED') {
      text = 'Đã hủy';
      color = Colors.black;
    }

    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNotice(BookingBlocModel bookingObj) {
    if (bookingObj.weatherWarnings.isNotEmpty ||
        bookingObj.locationWarnings.isNotEmpty ||
        bookingObj.timeWarnings.isNotEmpty ||
        bookingObj.selfWarnDistance.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            bookingObj.weatherWarnings.isNotEmpty
                ? Column(
                    children: bookingObj.weatherWarnings
                        .asMap()
                        .entries
                        .map((MapEntry map) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.cloud_off_outlined,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                  child: Text(
                                bookingObj.weatherWarnings[map.key].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      );
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
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
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
                            height: 5,
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
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
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
                            height: 5,
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
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
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
                            height: 5,
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : SizedBox(),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.blocPendingBookings.length,
      itemBuilder: (BuildContext context, int index) {
        BookingBlocModel pendingBooking = widget.blocPendingBookings[index];
        int listNoticeLength = pendingBooking.locationWarnings.length +
            pendingBooking.weatherWarnings.length +
            pendingBooking.timeWarnings.length +
            pendingBooking.selfWarnDistance.length;
        return GestureDetector(
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
                          parent: animation, curve: Curves.fastOutSlowIn);
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
                                bookingRepository: _bookingRepository),
                          ),
                          BlocProvider(
                            create: (context) => CommentBloc(
                                commentRepository: _commentRepository),
                          ),
                        ],
                        child: BookingDetailScreen(
                          onCheckIfEdited: (bool isEdited) {
                            widget.isEdited(isEdited);
                          },
                          bookingId: pendingBooking.id,
                        ),
                      );
                    }));
          },
          child: Stack(
            children: [
              listNoticeLength != 0
                  ? Positioned(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 5),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ],
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                          ),
                          child: _buildNotice(BookingBlocModel(
                              timeWarnings: pendingBooking.timeWarnings,
                              locationWarnings: pendingBooking.locationWarnings,
                              weatherWarnings: pendingBooking.weatherWarnings,
                              selfWarnDistance:
                                  pendingBooking.selfWarnDistance)),
                        ),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: listNoticeLength != 0
                    ? EdgeInsets.only(
                        bottom: listNoticeLength == 1
                            ? 60.0
                            : (listNoticeLength * 55.0 - listNoticeLength * 6))
                    : EdgeInsets.zero,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
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
                                'Yêu cầu từ ${pendingBooking.customer.fullname}',
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
                                statusFormat(pendingBooking.status),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
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
                                  pendingBooking.serviceName,
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
                                pendingBooking.listTimeAndLocations.isEmpty
                                    ? ''
                                    : pendingBooking
                                                .listTimeAndLocations.length >
                                            1
                                        ? 'Nhiều mốc thời gian'
                                        : pendingBooking
                                                    .listTimeAndLocations[0] ==
                                                null
                                            ? ''
                                            : DateFormat('dd/MM/yyyy hh:mm a')
                                                .format(DateTime.parse(
                                                        pendingBooking
                                                            .listTimeAndLocations[
                                                                0]
                                                            .start)
                                                    .toLocal()),
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
                                  pendingBooking.listTimeAndLocations.isEmpty
                                      ? ''
                                      : pendingBooking
                                                  .listTimeAndLocations.length >
                                              1
                                          ? 'Nhiều địa điểm'
                                          : pendingBooking.listTimeAndLocations[
                                                      0] ==
                                                  null
                                              ? ''
                                              : pendingBooking
                                                  .listTimeAndLocations[0]
                                                  .formattedAddress,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        pendingBooking.isMultiday
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.assistant_photo_outlined,
                                      size: 17,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Text(
                                      'Chụp nhiều ngày',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
