import 'dart:async';

import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:customer_app_java_support/blocs/notification_blocs/notifications.dart';
import 'package:customer_app_java_support/blocs/report_blocs/reports.dart';
import 'package:customer_app_java_support/models/notification_bloc_model.dart';
import 'package:customer_app_java_support/respositories/booking_repository.dart';
import 'package:customer_app_java_support/respositories/comment_repository.dart';
import 'package:customer_app_java_support/respositories/report_repository.dart';
import 'package:customer_app_java_support/screens/history_screens/booking_detail_screen.dart';
import 'package:customer_app_java_support/shared/scale_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  BookingRepository _bookingRepository =
      BookingRepository(httpClient: http.Client());
  CommentRepository _commentRepository =
      CommentRepository(httpClient: http.Client());
  ReportRepository _reportRepository =
      ReportRepository(httpClient: http.Client());
  Completer<void> _completer;
  List<NotificationBlocModel> listNotifications = List<NotificationBlocModel>();

  int checkInNotificationId;
  _loadEvent() async {
    BlocProvider.of<NotificationBloc>(context).add(NotificationEventFetch());
  }

  _checkInAll(int bookingId) async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventCheckInAll(bookingId: bookingId));
  }

  bool isHighLightText = false;

  _deleteAEvent(int id) async {
    BlocProvider.of<NotificationBloc>(context)
        .add(NotificationEventDeleteANotification(id: id));
  }

  IconData formatIconsFromType(String notificationType) {
    switch (notificationType) {
      case 'BOOKING_STATUS':
        return Icons.assistant_photo_sharp;
        break;
      case 'WARNING':
        return Icons.warning_amber_outlined;
        break;
      case 'TIME_NOTIFICATION':
        return Icons.access_time;
        break;
      case 'REQUEST_RESULT':
        return Icons.done;
        break;
      case 'CONFIRMATION_REQUEST':
        return Icons.qr_code_rounded;
        break;
      default:
        return Icons.access_alarm;
    }
  }

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();
    _loadEvent();
  }

  Widget notificationWidget(NotificationBlocModel notification) {
    if (notification.bookingId == null) {
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.3,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      formatIconsFromType(notification.notificationType),
                      color: Colors.pink,
                      size: 45.0,
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      width: 240.0,
                      child: Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 15.0,
                          wordSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(left: 55.0),
                  child: Text(
                    notification.createdAt == null
                        ? DateFormat('dd/MM/yyyy hh:mm a')
                            .format(DateTime.now())
                        : DateFormat('dd/MM/yyyy hh:mm a')
                            .format(DateTime.parse(notification.createdAt)),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        secondaryActions: [
          IconSlideAction(
            caption: "Xóa",
            color: Theme.of(context).primaryColor,
            icon: Icons.close,
            closeOnTap: false,
            onTap: () {
              return _deleteAEvent(notification.id);
            },
          )
        ],
      );
    } else if (notification.notificationType == 'CONFIRMATION_REQUEST') {
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.3,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      formatIconsFromType(notification.notificationType),
                      color: Colors.pink,
                      size: 45.0,
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      width: 180.0,
                      child: Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 15.0,
                          wordSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          _showConfirmCheckInAlert(notification.bookingId);
                          checkInNotificationId = notification.id;
                        },
                        child: Text('Check-in',
                            style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold)),
                        color: Colors.transparent,
                        focusColor: Colors.white,
                        splashColor: Colors.pink[200],
                        highlightColor: Colors.pink[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.pink)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(left: 55.0),
                  child: Text(
                    notification.createdAt == null
                        ? DateFormat('dd/MM/yyyy hh:mm a')
                            .format(DateTime.now())
                        : DateFormat('dd/MM/yyyy hh:mm a')
                            .format(DateTime.parse(notification.createdAt)),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        secondaryActions: [
          IconSlideAction(
            caption: "Xóa",
            color: Theme.of(context).primaryColor,
            icon: Icons.close,
            closeOnTap: false,
            onTap: () {
              return _deleteAEvent(notification.id);
            },
          )
        ],
      );
    } else {
      return InkWell(
        onTap: () {
          scaleNavigator(
              context,
              MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) =>
                          BookingBloc(bookingRepository: _bookingRepository)),
                  BlocProvider(
                      create: (context) =>
                          CommentBloc(commentRepository: _commentRepository)),
                  BlocProvider(
                      create: (context) =>
                          ReportBloc(reportRepository: _reportRepository)),
                ],
                child: BookingDetailScreen(
                  bookingId: notification.bookingId,
                  isEdited: (bool _isEdited) {},
                ),
              ));
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.3,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        formatIconsFromType(notification.notificationType),
                        color: Colors.pink,
                        size: 45.0,
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        width: 240.0,
                        child: Text(
                          notification.title ?? '',
                          style: TextStyle(
                            fontSize: 15.0,
                            wordSpacing: 1.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(left: 55.0),
                    child: Text(
                      notification.createdAt == null
                          ? DateFormat('dd/MM/yyyy hh:mm a')
                              .format(DateTime.now().toLocal())
                          : DateFormat('dd/MM/yyyy hh:mm a').format(
                              DateTime.parse(notification.createdAt).toLocal()),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          secondaryActions: [
            IconSlideAction(
              caption: "Xóa",
              color: Theme.of(context).primaryColor,
              icon: Icons.close,
              closeOnTap: false,
              onTap: () {
                return _deleteAEvent(notification.id);
              },
            )
          ],
        ),
      );
    }
  }

  Widget listNotification(List<NotificationBlocModel> notifications) {
    return Column(
      children: notifications.asMap().entries.map((MapEntry map) {
        NotificationBlocModel notification = notifications[map.key];
        return notificationWidget(notification);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationStateDeleteANotifcationSuccess) {
                _loadEvent();
                // popUp(context, 'Xoá thông báo', 'Đã xóa thông báo');
              }
            },
          ),
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingStateCheckInAllSuccess) {
                Navigator.pop(context);
                _showSuccessAlert('Hoàn thành', 'Check-in hoàn tất');
                _deleteAEvent(checkInNotificationId);
              }
              if (state is BookingStateFailure) {
                Navigator.pop(context);
                _showFailAlert(
                    'Thất bại', 'Đã có lỗi xảy ra trong lúc gửi yêu cầu!');
              }
              if (state is BookingStateLoading) {
                _showLoadingAlert();
              }
            },
          ),
        ],
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (BuildContext context, state) {
                if (state is NotificationStateLoading) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Center(
                        child: Container(child: CircularProgressIndicator())),
                  );
                }
                if (state is NotificationStateFetchSuccess) {
                  if (state.notifications.isEmpty ||
                      state.notifications == null) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Hiện tại chưa có thông báo nào dành cho bạn!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    listNotifications = state.notifications;
                    return RefreshIndicator(
                        onRefresh: () {
                          _loadEvent();
                          return _completer.future;
                        },
                        child: listNotification(state.notifications));
                  }
                }
                if (state is NotificationStateFailure) {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã xảy ra lỗi khi tải dữ liệu',
                            style:
                                TextStyle(color: Colors.red[300], fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              _loadEvent();
                            },
                            child: Text(
                              'Nhấn để tải lại',
                              style: TextStyle(
                                  color: Colors.red[300], fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return listNotification(listNotifications);
              },
            ),
          ],
        ),
      ),
    );
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

  Future<void> _showConfirmCheckInAlert(int bookingId) async {
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
                'Xác nhận check-in tất cả các ngày chụp?',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () {
                Navigator.pop(context);
                _checkInAll(bookingId);
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

  Future<void> _showSuccessAlert(String title, String content) async {
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
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
