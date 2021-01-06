import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:customer_app_java_support/models/weather_bloc_model.dart';

abstract class WarningState extends Equatable {
  const WarningState();

  @override
  List<Object> get props => [];
}

class WarningStateLoading extends WarningState {}

class WarningStateCheckOutOfWorkingTimeSuccess extends WarningState {
  final bool isOutOfWorkingTime;
  const WarningStateCheckOutOfWorkingTimeSuccess(
      {@required this.isOutOfWorkingTime})
      : assert(isOutOfWorkingTime != null);
  @override
  List<Object> get props => [isOutOfWorkingTime];

  @override
  String toString() =>
      'WarningStateCheckOutOfWorkingTimeSuccess { isOutOfWorkingTime: $isOutOfWorkingTime }';
}

class WarningStateGetTimeWarningSuccess extends WarningState {
  final List<String> notices;
  const WarningStateGetTimeWarningSuccess({@required this.notices})
      : assert(notices != null);
  @override
  List<Object> get props => [notices];

  @override
  String toString() =>
      'WarningStateGetTimeWarningSuccess { warning: $notices }';
}

class WarningStateGetLocationWarningSuccess extends WarningState {
  final List<String> notices;
  const WarningStateGetLocationWarningSuccess({@required this.notices})
      : assert(notices != null);
  @override
  List<Object> get props => [notices];

  @override
  String toString() =>
      'WarningStateWarningStateGetLocationWarningSuccessGetWarningSuccess { warning: $notices }';
}

class WarningStateGetWeatherWarningSuccess extends WarningState {
  final WeatherBlocModel notice;
  const WarningStateGetWeatherWarningSuccess({@required this.notice})
      : assert(notice != null);
  @override
  List<Object> get props => [notice];

  @override
  String toString() =>
      'WarningStateGetWeatherWarningSuccess { warning: $notice }';
}

// class WarningStateGetWeatherWarningSuccess extends WarningState {
//   final List<String> notices;
//   const WarningStateGetWeatherWarningSuccess({@required this.notices})
//       : assert(notices != null);
//   @override
//   List<Object> get props => [notices];

//   @override
//   String toString() =>
//       'WarningStateGetWeatherWarningSuccess { warning: $notices }';
// }

class WarningStateFailure extends WarningState {
  final String error;
  WarningStateFailure({
    this.error,
  });
}
