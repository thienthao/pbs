import 'package:customer_app_1_11/models/booking_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class BookingStateSuccess extends BookingState {
  final List<BookingBlocModel> bookings;
  const BookingStateSuccess({@required this.bookings})
      : assert(bookings != null);
  @override
  List<Object> get props => [bookings];

  @override
  String toString() => 'BookingsLoadSuccess { Booking: $bookings }';
}

class BookingStateFailure extends BookingState {}
