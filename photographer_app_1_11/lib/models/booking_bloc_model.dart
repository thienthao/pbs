import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:photographer_app_1_11/models/customer_bloc_model.dart';

import 'package:photographer_app_1_11/models/package_bloc_model.dart';
import 'package:photographer_app_1_11/models/photographer_bloc_model.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'serviceName': serviceName,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'customerCanceledReason': customerCanceledReason,
      'photographerCanceledReason': photographerCanceledReason,
      'rejectedReason': rejectedReason,
      'rating': rating,
      'comment': comment,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'commentDate': commentDate,
      'services': services,
      'photographer': photographer?.toMap(),
      'customer': customer,
      'package': package?.toMap(),
    };
  }

  factory BookingBlocModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BookingBlocModel(
      id: map['id'],
      status: map['status'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      serviceName: map['serviceName'],
      price: map['price'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      customerCanceledReason: map['customerCanceledReason'],
      photographerCanceledReason: map['photographerCanceledReason'],
      rejectedReason: map['rejectedReason'],
      rating: map['rating'],
      comment: map['comment'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      commentDate: map['commentDate'],
      services: map['servicePackage']['services'],
      photographer: Photographer.fromMap(map['photographer']),
      package: PackageBlocModel.fromMap(map['package']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingBlocModel.fromJson(String source) =>
      BookingBlocModel.fromMap(json.decode(source));
}
