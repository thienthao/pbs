import 'package:photographer_app/models/booking_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookingEventFetch extends BookingEvent {}

class BookingEventFetchByPending extends BookingEvent {}

class BookingEventDetailFetch extends BookingEvent {
  final int id;

  BookingEventDetailFetch({this.id});
}

class BookingEventCreate extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventCreate({this.booking});
}

class BookingEventCancel extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventCancel({this.booking});
}

class BookingEventAccept extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventAccept({this.booking});
}

class BookingEventReject extends BookingEvent {
  final BookingBlocModel booking;
  BookingEventReject({this.booking});
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
