import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:photographer_app_java_support/models/busy_day_bloc_model.dart';

abstract class BusyDayState extends Equatable {
  const BusyDayState();

  @override
  List<Object> get props => [];
}

class BusyDayStateLoading extends BusyDayState {}

class BusyDayStateFetchSuccess extends BusyDayState {
  final List<BusyDayBlocModel> listBusyDays;
  const BusyDayStateFetchSuccess({@required this.listBusyDays})
      : assert(listBusyDays != null);
  @override
  List<Object> get props => [listBusyDays];

  @override
  String toString() => 'BusyDayStateFetchSuccess { days: $listBusyDays }';
}

class BusyDayStateUpdatedSuccess extends BusyDayState {
  final bool isUpdateSuccess;

  const BusyDayStateUpdatedSuccess({@required this.isUpdateSuccess})
      : assert(isUpdateSuccess != null);
  @override
  List<Object> get props => [isUpdateSuccess];

  @override
  String toString() =>
      'BusyDayStateUpdatedSuccess { update working day: $isUpdateSuccess }';
}

class BusyDayStateCreatedSuccess extends BusyDayState {
  final bool isCreatedSuccess;

  const BusyDayStateCreatedSuccess({@required this.isCreatedSuccess})
      : assert(isCreatedSuccess != null);
  @override
  List<Object> get props => [isCreatedSuccess];

  @override
  String toString() =>
      'BusyDayStateCreatedSuccess { update working day: $isCreatedSuccess }';
}

class BusyDayStateDeletedSuccess extends BusyDayState {
  final bool isDeletedSuccess;

  const BusyDayStateDeletedSuccess({@required this.isDeletedSuccess})
      : assert(isDeletedSuccess != null);
  @override
  List<Object> get props => [isDeletedSuccess];

  @override
  String toString() =>
      'BusyDayStateDeletedSuccess { update working day: $isDeletedSuccess }';
}

class BusyDayStateFailure extends BusyDayState {
  final String error;
  BusyDayStateFailure({
    this.error,
  });
  
}
