import 'dart:convert';

import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:equatable/equatable.dart';

class BookingBlocModel extends Equatable {
  final int id;
  final String status;
  final String startDate;
  final String editDeadLine;
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
  final String address;
  final double latitude;
  final double longitude;
  final String commentDate;
  final String packageDescription;
  final Photographer photographer;
  final PackageBlocModel package;
  final int returningType;
  final bool isMultiday;
  final List<String> services;
  final List<TimeAndLocationBlocModel> listTimeAndLocations;

  BookingBlocModel(
      {this.id,
      this.isMultiday,
      this.status,
      this.startDate,
      this.endDate,
      this.editDeadLine,
      this.serviceName,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.customerCanceledReason,
      this.photographerCanceledReason,
      this.rejectedReason,
      this.rating,
      this.comment,
      this.address,
      this.latitude,
      this.longitude,
      this.commentDate,
      this.packageDescription,
      this.photographer,
      this.package,
      this.returningType,
      this.services,
      this.listTimeAndLocations});

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
      address,
      latitude,
      longitude,
      commentDate,
      packageDescription,
      photographer,
      package,
      services
    ];
  }
}
