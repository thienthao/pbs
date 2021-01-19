import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authen_export.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/blocs/comment_blocs/comments.dart';
import 'package:photographer_app_java_support/blocs/notification_blocs/notifications.dart';
import 'package:photographer_app_java_support/blocs/report_blocs/reports.dart';
import 'package:photographer_app_java_support/models/notification_bloc_model.dart';
import 'package:photographer_app_java_support/respositories/booking_repository.dart';
import 'package:photographer_app_java_support/respositories/comment_repository.dart';
import 'package:photographer_app_java_support/respositories/report_repository.dart';
import 'package:photographer_app_java_support/screens/history_screens/booking_detail_screen.dart';
import 'package:photographer_app_java_support/widgets/shared/pop_up.dart';
import 'package:photographer_app_java_support/widgets/shared/scale_navigator.dart';

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
  _loadEvent() async {
    BlocProvider.of<NotificationBloc>(context).add(NotificationEventFetch());
  }

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
                      width: 230.0,
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
                SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.only(right: 100.0),
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
                        ReportBloc(reportRepository: _reportRepository),
                  ),
                ],
                child: BookingDetailScreen(
                  bookingId: notification.bookingId,
                  onCheckIfEdited: (bool _isEdited) {},
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
                        width: 230.0,
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
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(right: 100.0),
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
          style: TextStyle(
            fontSize: 28.0,
            letterSpacing: -1,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationStateFailure) {
                String error = state.error.replaceAll('Exception: ', '');
                if (error.toUpperCase() == 'UNAUTHORIZED') {
                  _showUnauthorizedDialog();
                } else {
                  popUp(context, 'Xoá thông báo',
                      'Đã có lỗi xảy ra trong lúc xóa thông báo. Vui lòng thử lại sao');
                }
              }
              if (state is NotificationStateDeleteANotifcationSuccess) {
                _loadEvent();
                // popUp(context, 'Xoá thông báo', 'Đã xóa thông báo');
              }
            },
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
                        BlocProvider.of<NotificationBloc>(context)
                            .add(NotificationEventInitial());
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
                            BlocProvider.of<NotificationBloc>(context)
                                .add(NotificationEventInitial());
                            _loadEvent();
                          },
                          child: Text(
                            'Ấn để tải lại',
                            style:
                                TextStyle(color: Colors.red[300], fontSize: 16),
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
}
