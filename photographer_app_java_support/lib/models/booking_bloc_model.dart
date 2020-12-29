import 'package:equatable/equatable.dart';
import 'package:photographer_app_java_support/models/customer_bloc_model.dart';

import 'package:photographer_app_java_support/models/package_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:photographer_app_java_support/models/time_and_location_bloc_model.dart';
import 'package:photographer_app_java_support/models/weather_bloc_model.dart';

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
  final int returningType;
  final bool isMultiday;
  final String editDeadLine;
  final CustomerBlocModel customer;
  final PackageBlocModel package;
  final List<TimeAndLocationBlocModel> listTimeAndLocations;
  final List<String> services;
  final List<String> timeWarnings;
  final List<String> locationWarnings;
  final List<String> weatherWarnings;
  final List<String> selfWarnDistance;
  final List<WeatherBlocModel> listWeatherNoticeDetails;
  final String returningLink;
  final int timeAnticipate;

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
      this.services,
      this.returningType,
      this.isMultiday,
      this.listTimeAndLocations,
      this.editDeadLine,
      this.timeWarnings,
      this.locationWarnings,
      this.weatherWarnings,
      this.selfWarnDistance,
      this.returningLink,
      this.listWeatherNoticeDetails,
      this.timeAnticipate});

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
