import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingStateLoading extends BookingState {}

class BookingStateFetchByDateInProgress extends BookingState {}

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
  final bool isSuccess;
  BookingStateCreatedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Created: $isSuccess }';
}

class BookingStateCanceledSuccess extends BookingState {
  final bool isSuccess;
  BookingStateCanceledSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Canceled: $isSuccess }';
}

class BookingStateAcceptedSuccess extends BookingState {
  final bool isSuccess;
  BookingStateAcceptedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Accept: $isSuccess }';
}

class BookingStateMovedToEditSuccess extends BookingState {
  final bool isSuccess;
  BookingStateMovedToEditSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Accept: $isSuccess }';
}

class BookingStateMovedToDoneSuccess extends BookingState {
  final bool isSuccess;
  BookingStateMovedToDoneSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Accept: $isSuccess }';
}

class BookingStateRejectedSuccess extends BookingState {
  final bool isSuccess;
  BookingStateRejectedSuccess({@required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];

  @override
  String toString() =>
      'BookingStateCreatedSuccess { Booking Reject: $isSuccess }';
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

class BookingStateFetchedByDateSuccess extends BookingState {
  final List<BookingBlocModel> bookings;
  const BookingStateFetchedByDateSuccess({@required this.bookings})
      : assert(bookings != null);
  @override
  List<Object> get props => [bookings];

  @override
  String toString() =>
      'BookingStateFetchedByDateSuccess { Booking List Fetched By Date: $bookings }';
}

class BookingStateInitialPagingFetched extends BookingState {}

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

class BookingStateFailure extends BookingState {}
