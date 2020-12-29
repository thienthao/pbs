import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookingEventFetch extends BookingEvent {
  final int cusId;

  BookingEventFetch({this.cusId});
}

class BookingRestartEvent extends BookingEvent {}

class BookingEventDetailFetch extends BookingEvent {
  final int id;

  BookingEventDetailFetch({this.id});
}

class BookingEventFetchInfinite extends BookingEvent {
  final int cusId;
  final String status;
  BookingEventFetchInfinite({this.cusId, this.status});
}

class BookingEventCreate extends BookingEvent {
  final BookingBlocModel booking;
  final int cusId;
  BookingEventCreate({this.booking, this.cusId});
}

class BookingEventEdit extends BookingEvent {
  final BookingBlocModel booking;
  final int cusId;
  BookingEventEdit({this.booking, this.cusId});
}

class BookingEventCancel extends BookingEvent {
  final BookingBlocModel booking;
  final int cusId;
  BookingEventCancel({this.booking, this.cusId});
}

class BookingEventGetBookingOnDate extends BookingEvent {
  final int ptgId;
  final String date;

  BookingEventGetBookingOnDate({this.ptgId, this.date});
}

class BookingEventLoadSuccess extends BookingEvent {
  BookingEventLoadSuccess(List<BookingBlocModel> list);
}

class BookingEventRequested extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventRequested({
    @required this.booking,
  }) : assert(booking != null);
  @override
  List<Object> get props => [booking];
}

class BookingEventRefresh extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventRefresh({
    @required this.booking,
  }) : assert(booking != null);
  @override
  List<Object> get props => [booking];
}
