import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:photographer_app_java_support/models/calendar_model.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarStateLoading extends CalendarState {}

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

class CalendarStateFailure extends CalendarState {
  final String error;
  CalendarStateFailure({
    this.error,
  });
}
