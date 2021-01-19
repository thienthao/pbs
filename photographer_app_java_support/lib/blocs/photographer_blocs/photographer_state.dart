import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';

abstract class PhotographerState extends Equatable {
  const PhotographerState();

  @override
  List<Object> get props => [];
}

class PhotographerStateLoading extends PhotographerState {}

class PhotographerStateSuccess extends PhotographerState {
  final List<Photographer> photographers;
  const PhotographerStateSuccess({@required this.photographers})
      : assert(photographers != null);
  @override
  List<Object> get props => [photographers];

  @override
  String toString() =>
      'PhotographersLoadSuccess { photographers: $photographers }';
}

class PhotographerStateOnChangedAvatarSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateOnChangedAvatarSuccess({this.isSuccess});
}

class PhotographerStateOnChangedCoverSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateOnChangedCoverSuccess({this.isSuccess});
}

class PhotographerStateUpdatedProfileSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateUpdatedProfileSuccess({this.isSuccess});
}

class PhotographerStateGetLocationsSuccess extends PhotographerState {
  final List<LocationBlocModel> locations;
  PhotographerStateGetLocationsSuccess({this.locations});
}

class PhotographerStateUpdatedLocationsSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateUpdatedLocationsSuccess({this.isSuccess});
}

class PhotographerStateChangedPasswordSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateChangedPasswordSuccess({this.isSuccess});
}

class PhotographerStateRecoveryPasswordSuccess extends PhotographerState {
  final bool isSuccess;
  PhotographerStateRecoveryPasswordSuccess({this.isSuccess});
}

class PhotographerStateLocationUpdatedFail extends PhotographerState {}

class PhotographerIDStateSuccess extends PhotographerState {
  final Photographer photographer;
  const PhotographerIDStateSuccess({@required this.photographer})
      : assert(photographer != null);
  @override
  List<Object> get props => [photographer];

  @override
  String toString() =>
      'PhotographersLoadSuccess { photographers: $photographer }';
}

class PhotographerStateFailure extends PhotographerState {
  final dynamic error;
  PhotographerStateFailure({
    this.error,
  });
}
