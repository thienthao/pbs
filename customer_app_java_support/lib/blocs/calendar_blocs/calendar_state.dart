import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/calendar_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarStateLoading extends CalendarState {}

class CalendarStateGetBookingLoading extends CalendarState {}

class CalendarStatePhotographerDaysSuccess extends CalendarState {
  final CalendarModel photographerDays;
  const CalendarStatePhotographerDaysSuccess({@required this.photographerDays})
      : assert(photographerDays != null);
  @override
  List<Object> get props => [photographerDays];

  @override
  String toString() =>
      'CalendarStatePhotographerDaysSuccess { days: $photographerDays }';
}

class CalendarStateGetBookingSuccess extends CalendarState {
  final List<BookingBlocModel> listBookings;
  const CalendarStateGetBookingSuccess({@required this.listBookings})
      : assert(listBookings != null);
  @override
  List<Object> get props => [listBookings];

  @override
  String toString() =>
      'CalendarStateGetBookingSuccess { listBookingByDate: $listBookings }';
}

class CalendarStateFailure extends CalendarState {}


