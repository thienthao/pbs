import 'package:customer_app_java_support/models/working_date_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WorkingDayState extends Equatable {
  const WorkingDayState();

  @override
  List<Object> get props => [];
}

class WorkingDayStateLoading extends WorkingDayState {}

class WorkingDayStateFetchSuccess extends WorkingDayState {
  final List<WorkingDayBlocModel> listWorkingDays;
  const WorkingDayStateFetchSuccess({@required this.listWorkingDays})
      : assert(listWorkingDays != null);
  @override
  List<Object> get props => [listWorkingDays];

  @override
  String toString() => 'WorkingDayStateFetchSuccess { days: $listWorkingDays }';
}

class WorkingDayStateUpdateSuccess extends WorkingDayState {
  final bool isUpdateSuccess;

  const WorkingDayStateUpdateSuccess({@required this.isUpdateSuccess})
      : assert(isUpdateSuccess != null);
  @override
  List<Object> get props => [isUpdateSuccess];

  @override
  String toString() =>
      'WorkingDayStateUpdateSuccess { update working day: $isUpdateSuccess }';
}

class WorkingDayStateFailure extends WorkingDayState {}
