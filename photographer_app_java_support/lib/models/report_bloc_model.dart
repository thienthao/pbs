import 'package:equatable/equatable.dart';
import 'package:photographer_app_java_support/models/booking_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';

class ReportBlocModel extends Equatable {
  final int id;
  final String title;
  final String reason;
  final Photographer photographer;
  final String createdAt;
  final BookingBlocModel booking;

  const ReportBlocModel({
    this.id,
    this.title,
    this.reason,
    this.booking,
    this.photographer,
    this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        title,
        reason,
        booking,
        photographer,
        createdAt,
      ];
}
