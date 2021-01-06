import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:photographer_app_java_support/blocs/authen_blocs/authen_export.dart';
import 'package:photographer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:photographer_app_java_support/widgets/customshapeclipper.dart';
import 'package:photographer_app_java_support/widgets/history/booking_widget.dart';
import 'package:photographer_app_java_support/widgets/history/drop_menu_history.dart';
import 'package:photographer_app_java_support/widgets/shared/list_booking_loading.dart';

import '../../globals.dart';

class BookHistory extends StatefulWidget {
  @override
  _BookHistoryState createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  static const String AUTO_FIRST_STATUS = 'ALL';
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 0.0;
  String statusForFilter = 'ALL';
  bool isBookingEdited = false;
  DatabaseReference _notificationRef;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Completer<void> _completer;

  @override
  void initState() {
    super.initState();

    _completer = Completer<void>();
    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
    _loadBookingsByPaging(AUTO_FIRST_STATUS);

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreshold) {
        print('scroll on $statusForFilter');
        _loadBookingsByPaging(statusForFilter);
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    if (isBookingEdited) {
      _loadBookingsByPaging(AUTO_FIRST_STATUS);
      setState(() {});
    }
  }

  _loadBookingsByPaging(String _status) async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventFetchInfinite(status: _status));
  }

  _restartEvent() async {
    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
  }

  Widget refreshData() {
    return Expanded(
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingStateFailure) {
            String error = state.error.replaceAll('Exception: ', '');
            if (error.toUpperCase() == 'UNAUTHORIZED') {
              _showUnauthorizedDialog();
            }
          }
        },
        builder: (context, bookingState) {
          if (bookingState is BookingStateInitialPagingFetched) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            );
          }
          if (bookingState is BookingStateInfiniteFetchedSuccess) {
            if (bookingState.bookings.isEmpty) {
              return Center(
                child: Text(
                  'Hiện tại bạn chưa có lịch hẹn nào',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () {
                  BlocProvider.of<BookingBloc>(context)
                      .add(BookingRestartEvent());
                  _loadBookingsByPaging(statusForFilter);
                  return _completer.future;
                },
                child: Container(
                  child: BookingWidget(
                    hasReachedEnd: bookingState.bookings.length < 4
                        ? true
                        : bookingState.hasReachedEnd,
                    blocBookings: bookingState.bookings,
                    onGoBack: onGoBack,
                    isEdited: (bool _isEdited) {
                      isBookingEdited = _isEdited;
                    },
                    scrollController: _scrollController,
                  ),
                ),
              );
            }
          }

          if (bookingState is BookingStateLoading) {
            return ListBookingLoadingWidget();
          }

          if (bookingState is BookingStateFailure) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đã xảy ra lỗi khi tải dữ liệu',
                  style: TextStyle(color: Colors.red[300], fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    _loadBookingsByPaging(statusForFilter);
                  },
                  child: Text(
                    'Nhấn để tải lại',
                    style: TextStyle(color: Colors.red[300], fontSize: 16),
                  ),
                ),
              ],
            );
          }
          // final bookings = (bookingState as BookingStateSuccess).bookings;
          // return RefreshIndicator(
          //     child: Container(child: BookingWidget()),
          //     onRefresh: () {
          //       // BlocProvider.of<BookingBloc>(context)
          //       //     .add(BookingEventRefresh(booking: bookings[0]));
          //       return _completer.future;
          //     });
          return Text('');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _notificationRef = FirebaseDatabase.instance
        .reference()
        .child('Notification_$globalPtgId');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: -1,
          ),
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
      body: StreamBuilder(
          stream: _notificationRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data.snapshot.value != null) {
              _restartEvent();
              _loadBookingsByPaging(statusForFilter);
            }
            return Column(
              children: [
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFF88F8F),
                            Color(0xFFF88Fa9),
                          ]),
                        ),
                        height: 120.0,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                      height: 54.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: DropMenu(
                        onSelectParam: (String selectedStatus) {
                          print(selectedStatus.compareTo(statusForFilter));
                          if (selectedStatus == statusForFilter) {
                            statusForFilter = selectedStatus;
                            _loadBookingsByPaging(statusForFilter);
                          } else {
                            statusForFilter = selectedStatus;
                            _restartEvent();
                            _loadBookingsByPaging(statusForFilter);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                refreshData(),
              ],
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
}
