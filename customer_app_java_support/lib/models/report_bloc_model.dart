import 'package:customer_app_java_support/models/booking_bloc_model.dart';
import 'package:customer_app_java_support/models/customer_bloc_model.dart';
import 'package:equatable/equatable.dart';

class ReportBlocModel extends Equatable {
  final int id;
  final String title;
  final String reason;
  final CustomerBlocModel customer;
  final String createdAt;
  final BookingBlocModel booking;

  const ReportBlocModel(
      {this.id,
      this.title,
      this.reason,
      this.customer,
      this.createdAt,
      this.booking});

  @override
  List<Object> get props => [
        id,
        title,
        reason,
        customer,
        createdAt,
        booking,
      ];
}
