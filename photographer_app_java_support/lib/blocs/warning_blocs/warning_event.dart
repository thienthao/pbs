import 'package:equatable/equatable.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';

abstract class WarningEvent extends Equatable {
  const WarningEvent();

  @override
  List<Object> get props => [];
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
