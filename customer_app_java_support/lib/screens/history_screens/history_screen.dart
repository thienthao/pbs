import 'dart:async';

import 'package:customer_app_java_support/blocs/booking_blocs/bookings.dart';
import 'package:customer_app_java_support/shared/list_booking_loading.dart';
import 'package:customer_app_java_support/widgets/history_screen/booking_widget.dart';
import 'package:customer_app_java_support/widgets/history_screen/customshapeclipper.dart';
import 'package:customer_app_java_support/widgets/history_screen/drop_menu_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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

    // BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
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

  _loadBookingsByPaging(String _status) async {
    BlocProvider.of<BookingBloc>(context)
        .add(BookingEventFetchInfinite(cusId: 2, status: _status));
  }

  FutureOr onGoBack(dynamic value) {
    if (isBookingEdited) {
      _loadBookingsByPaging(statusForFilter);
      setState(() {});
    }
  }

  _restartEvent() async {
    BlocProvider.of<BookingBloc>(context).add(BookingRestartEvent());
  }

  Widget refreshData() {
    return Expanded(
      child: Center(
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            if (bookingState is BookingStateInfiniteFetchedSuccess) {
              if (bookingState.bookings.isEmpty) {
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
                    BlocProvider.of<BookingBloc>(context)
                        .add(BookingRestartEvent());
                    _loadBookingsByPaging(statusForFilter);
                    return _completer.future;
                  },
                  child: Container(
                    child: BookingWidget(
                      scrollController: _scrollController,
                      hasReachedEnd: bookingState.hasReachedEnd,
                      blocBookings: bookingState.bookings,
                      onGoBack: onGoBack,
                      isEdited: (bool isEdit) {
                        isBookingEdited = isEdit;
                      },
                    ),
                  ),
                );
              }
            }

            if (bookingState is BookingStateLoading) {
              return ListBookingLoadingWidget();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: TextStyle(fontWeight: FontWeight.w600),
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
      body: Column(
        children: [
          //////////////////////////////////////////////////////// Filter
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
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
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
          ///////////////////////////////////////////////////////////////
          SizedBox(
            height: 20.0,
          ),
          refreshData(),
        ],
      ),
    );
  }
}
