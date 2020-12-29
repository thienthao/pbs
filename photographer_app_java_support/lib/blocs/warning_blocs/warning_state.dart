import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WarningState extends Equatable {
  const WarningState();

  @override
  List<Object> get props => [];
}

class WarningStateLoading extends WarningState {}

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

class WarningStateFailure extends WarningState {}
