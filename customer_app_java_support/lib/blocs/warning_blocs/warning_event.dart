import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class WarningEvent extends Equatable {
  const WarningEvent();

  @override
  List<Object> get props => [];
}

class WarningEventCheckOutOfWorkingTime extends WarningEvent {
  final int ptgId;
  final String time;

  WarningEventCheckOutOfWorkingTime({this.ptgId, this.time});
}

class WarningEventGetTimeWarning extends WarningEvent {
  final String dateTime;
  final int ptgId;

  WarningEventGetTimeWarning({this.dateTime, this.ptgId});
}

class WarningEventGetLocationWarning extends WarningEvent {
  final BookingBlocModel booking;
  WarningEventGetLocationWarning({this.booking});
}

class WarningEventGetWeatherWarning extends WarningEvent {
  final String dateTime;
  final LatLng latLng;
  final int timeAnticipate;
  WarningEventGetWeatherWarning({this.dateTime, this.latLng, @required this.timeAnticipate });
}
