import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:customer_app_java_support/models/booking_bloc_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingStateLoading extends BookingState {}

class BookingDetailStateSuccess extends BookingState {
  final BookingBlocModel booking;
  const BookingDetailStateSuccess({@required this.booking})
      : assert(booking != null);
  @override
  List<Object> get props => [booking];

  @override
  String toString() => 'BookingsLoadSuccess { Booking: $booking }';
}

class BookingStateCreatedSuccess extends BookingState {
  final int bookingId;
  BookingStateCreatedSuccess({@required this.bookingId});

  @override
  List<Object> get props => [bookingId];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Created: $bookingId }';
}

class BookingStateEditedSuccess extends BookingState {
  final bool isSuccess;
  BookingStateEditedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateEditedSuccess { Booking Updated: $isSuccess }';
}

class BookingStateCancelInProgress extends BookingState {}

class BookingStateCanceledSuccess extends BookingState {
  final bool isSuccess;
  BookingStateCanceledSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Canceled: $isSuccess }';
}

class BookingStateCancelFailure extends BookingState {
  final String error;
  BookingStateCancelFailure({
    this.error,
  });
}

class BookingStateCanceledPendingBookingSuccess extends BookingState {
  final bool isSuccess;
  BookingStateCanceledPendingBookingSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCanceledPendingBookingSuccess { Booking Canceled: $isSuccess }';
}

class BookingStateCheckInAllSuccess extends BookingState {
  final bool isSuccess;
  BookingStateCheckInAllSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCheckInAllSuccess { Booking Check In All: $isSuccess }';
}

class BookingStateSuccess extends BookingState {
  final List<BookingBlocModel> bookings;
  const BookingStateSuccess({@required this.bookings})
      : assert(bookings != null);
  @override
  List<Object> get props => [bookings];

  @override
  String toString() => 'BookingsLoadSuccess { Booking: $bookings }';
}

class BookingStateGetBookingByDateSuccess extends BookingState {
  final List<BookingBlocModel> listBookings;
  const BookingStateGetBookingByDateSuccess({@required this.listBookings})
      : assert(listBookings != null);
  @override
  List<Object> get props => [listBookings];

  @override
  String toString() =>
      'BookingStateGetBookingByDateSuccess { listBookingByDate: $listBookings }';
}

class BookingStateInfiniteFetchedSuccess extends BookingState {
  final bool hasReachedEnd;
  final List<BookingBlocModel> bookings;
  const BookingStateInfiniteFetchedSuccess({this.bookings, this.hasReachedEnd})
      : assert(bookings != null, hasReachedEnd != null);
  @override
  List<Object> get props => [bookings, hasReachedEnd];

  @override
  String toString() =>
      'BookingStatePagingFetchedSuccess { Booking: $bookings , hasReachedEnd: $hasReachedEnd}';

  BookingStateInfiniteFetchedSuccess cloneWith(
      {bool hasReachedEnd, List<BookingBlocModel> bookings}) {
    return BookingStateInfiniteFetchedSuccess(
        bookings: bookings ?? this.bookings,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd);
  }
}

class BookingStateFailure extends BookingState {
  final String error;
  BookingStateFailure({
    this.error,
  });
}
