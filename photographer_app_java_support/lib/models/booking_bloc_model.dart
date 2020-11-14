
import 'package:equatable/equatable.dart';
import 'package:photographer_app_java_support/models/customer_bloc_model.dart';

import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';

class BookingBlocModel extends Equatable {
  final int id;
  final String status;
  final String startDate;
  final String endDate;
  final String serviceName;
  final int price;
  final String createdAt;
  final String updatedAt;
  final String customerCanceledReason;
  final String photographerCanceledReason;
  final String rejectedReason;
  final double rating;
  final String comment;
  final String location;
  final double latitude;
  final double longitude;
  final String commentDate;
  final String packageDescription;
  final Photographer photographer;
  final CustomerBlocModel customer;
  final PackageBlocModel package;
  final List<String> services;

  BookingBlocModel(
      {this.id,
      this.status,
      this.startDate,
      this.endDate,
      this.serviceName,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.customerCanceledReason,
      this.photographerCanceledReason,
      this.rejectedReason,
      this.rating,
      this.comment,
      this.location,
      this.latitude,
      this.longitude,
      this.commentDate,
      this.packageDescription,
      this.photographer,
      this.customer,
      this.package,
      this.services});

  @override
  List<Object> get props {
    return [
      id,
      status,
      startDate,
      endDate,
      serviceName,
      price,
      createdAt,
      updatedAt,
      customerCanceledReason,
      photographerCanceledReason,
      rejectedReason,
      rating,
      comment,
      location,
      latitude,
      longitude,
      commentDate,
      packageDescription,
      photographer,
      customer,
      package,
      services
    ];
  }
  
}
